import 'dart:async';
import 'package:flutter/material.dart';
import '../../../auth/auth_manager.dart';
import '../supabase.dart';

export '../../../auth/base_auth_user_provider.dart';

class SupabaseAuthUser extends BaseAuthUser {
  SupabaseAuthUser(this.user);
  
  final User? user;
  
  @override
  bool get loggedIn => user != null;

  @override
  AuthUserInfo get authUserInfo => AuthUserInfo(
        uid: user?.id,
        email: user?.email,
        displayName: user?.userMetadata?['full_name'],
        photoUrl: user?.userMetadata?['photo_url'],
        phoneNumber: user?.phone,
      );

  @override
  Future? delete() => user != null ? SupaFlow.client.auth.admin.deleteUser(user!.id) : null;

  @override
  Future? updateEmail(String email) async {
    if (user != null) {
      await SupaFlow.client.auth.updateUser(UserAttributes(email: email));
    }
  }

  @override
  Future? updatePassword(String newPassword) async {
    if (user != null) {
      await SupaFlow.client.auth.updateUser(UserAttributes(password: newPassword));
    }
  }

  @override
  Future? sendEmailVerification() async {
    if (user?.email != null) {
      await SupaFlow.client.auth.resend(
        type: OtpType.signup,
        email: user!.email!,
      );
    }
  }

  @override
  bool get emailVerified => user?.emailConfirmedAt != null;

  @override
  Future refreshUser() async {
    await SupaFlow.client.auth.refreshSession();
  }

  static BaseAuthUser fromSupabaseUser(User? user) => SupabaseAuthUser(user);
}

class SupabaseAuthManager extends AuthManager
    with EmailSignInManager, AnonymousSignInManager, AppleSignInManager, 
         GoogleSignInManager, JwtSignInManager {
  static SupabaseAuthManager? _instance;
  static SupabaseAuthManager get instance => _instance ??= SupabaseAuthManager._();
  
  SupabaseAuthManager._();

  StreamSubscription<AuthState>? _authSubscription;
  final StreamController<BaseAuthUser?> _userController = StreamController<BaseAuthUser?>.broadcast();

  Stream<BaseAuthUser?> get userStream => _userController.stream;

  BaseAuthUser? get currentUser {
    final user = SupaFlow.client.auth.currentUser;
    return user != null ? SupabaseAuthUser.fromSupabaseUser(user) : null;
  }

  bool get loggedIn => SupaFlow.client.auth.currentUser != null;

  String? get currentUserUid => SupaFlow.client.auth.currentUser?.id;

  void initialize() {
    _authSubscription = SupaFlow.client.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      _userController.add(user != null ? SupabaseAuthUser.fromSupabaseUser(user) : null);
    });
  }

  @override
  Future<BaseAuthUser?> signInWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final response = await SupaFlow.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        await _syncUserWithSupabase(response.user!);
        return SupabaseAuthUser.fromSupabaseUser(response.user);
      }
      return null;
    } on AuthException catch (e) {
      _handleAuthError(context, e);
      return null;
    } catch (e) {
      _showError(context, 'Erro inesperado: ${e.toString()}');
      return null;
    }
  }

  @override
  Future<BaseAuthUser?> createAccountWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final response = await SupaFlow.client.auth.signUp(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        await _syncUserWithSupabase(response.user!);
        return SupabaseAuthUser.fromSupabaseUser(response.user);
      }
      return null;
    } on AuthException catch (e) {
      _handleAuthError(context, e);
      return null;
    } catch (e) {
      _showError(context, 'Erro inesperado: ${e.toString()}');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await SupaFlow.client.auth.signOut();
    } catch (e) {
      print('Erro ao fazer logout: $e');
    }
  }

  @override
  Future<void> deleteUser(BuildContext context) async {
    try {
      final user = SupaFlow.client.auth.currentUser;
      if (user != null) {
        await SupaFlow.client.auth.admin.deleteUser(user.id);
        _showSuccess(context, 'Conta deletada com sucesso!');
      }
    } on AuthException catch (e) {
      _handleAuthError(context, e);
    } catch (e) {
      _showError(context, 'Erro inesperado: ${e.toString()}');
    }
  }

  @override
  Future<void> updateEmail({
    required String email,
    required BuildContext context,
  }) async {
    try {
      if (!loggedIn) {
        _showError(context, 'Usuário não está logado');
        return;
      }
      
      await SupaFlow.client.auth.updateUser(UserAttributes(email: email));
      _showSuccess(context, 'Email atualizado com sucesso!');
    } on AuthException catch (e) {
      _handleAuthError(context, e);
    } catch (e) {
      _showError(context, 'Erro inesperado: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await SupaFlow.client.auth.resetPasswordForEmail(email);
      _showSuccess(context, 'Email de recuperação enviado com sucesso!');
    } on AuthException catch (e) {
      _handleAuthError(context, e);
    } catch (e) {
      _showError(context, 'Erro inesperado: ${e.toString()}');
    }
  }

  Future updatePassword({
    required String newPassword,
    required BuildContext context,
  }) async {
    try {
      if (!loggedIn) {
        _showError(context, 'Usuário não está logado');
        return;
      }
      
      await SupaFlow.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      _showSuccess(context, 'Senha atualizada com sucesso!');
    } on AuthException catch (e) {
      _handleAuthError(context, e);
    } catch (e) {
      _showError(context, 'Erro inesperado: ${e.toString()}');
    }
  }

  Future<void> _syncUserWithSupabase(User user) async {
    try {
      // Verifica se o usuário já existe na tabela app_users
      final existingUser = await SupaFlow.client
          .from('app_users')
          .select()
          .eq('currentUser_UID_Firebase', user.id)
          .maybeSingle();

      if (existingUser == null) {
        // Cria novo usuário na tabela app_users
        await SupaFlow.client.from('app_users').insert({
          'id': user.id,
          'email': user.email,
          'full_name': user.userMetadata?['full_name'] ?? '',
          'phone': user.phone ?? '',
          'photo_url': user.userMetadata?['photo_url'] ?? '',
          'user_type': '',
          'status': 'active',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'fcm_token': '',
          'device_id': '',
          'device_platform': '',
          'last_active_at': DateTime.now().toIso8601String(),
          'profile_complete': false,
          'onesignal_player_id': '',
          'currentUser_UID_Firebase': user.id,
        });
      } else {
        // Atualiza informações do usuário existente
        await SupaFlow.client
            .from('app_users')
            .update({
              'last_active_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('currentUser_UID_Firebase', user.id);
      }
    } catch (e) {
      print('Erro ao sincronizar usuário com Supabase: $e');
    }
  }

  void _handleAuthError(BuildContext context, AuthException e) {
    final errorMsg = switch (e.message.toLowerCase()) {
      String msg when msg.contains('invalid login credentials') => 
        'Email ou senha incorretos. Verifique suas credenciais.',
      String msg when msg.contains('email already registered') => 
        'Email já está em uso. Tente fazer login ou use outro email.',
      String msg when msg.contains('password should be at least') => 
        'A senha deve ter pelo menos 6 caracteres.',
      String msg when msg.contains('invalid email') => 
        'Email inválido. Verifique o formato do email.',
      String msg when msg.contains('signup is disabled') => 
        'Cadastro desabilitado. Entre em contato com o suporte.',
      String msg when msg.contains('email not confirmed') => 
        'Email não confirmado. Verifique sua caixa de entrada.',
      _ => 'Erro de autenticação: ${e.message}',
    };
    
    _showError(context, errorMsg);
  }

  void _showError(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccess(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void dispose() {
    _authSubscription?.cancel();
    _userController.close();
  }

  // Métodos não implementados para manter compatibilidade com AuthManager
  @override
  Future<BaseAuthUser?> signInAnonymously(BuildContext context) async {
    _showError(context, 'Login anônimo não suportado com Supabase Auth');
    return null;
  }

  @override
  Future<BaseAuthUser?> signInWithApple(BuildContext context) async {
    _showError(context, 'Login com Apple não implementado ainda');
    return null;
  }

  @override
  Future<BaseAuthUser?> signInWithGoogle(BuildContext context) async {
    _showError(context, 'Login com Google não implementado ainda');
    return null;
  }

  Future<BaseAuthUser?> signInWithGithub(BuildContext context) async {
    _showError(context, 'Login com Github não implementado ainda');
    return null;
  }

  @override
  Future<BaseAuthUser?> signInWithJwtToken(BuildContext context, String jwtToken) async {
    _showError(context, 'Login com JWT não implementado ainda');
    return null;
  }
}