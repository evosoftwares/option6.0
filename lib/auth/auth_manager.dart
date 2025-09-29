import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../backend/supabase/supabase.dart';
import '../backend/supabase/database/tables/app_users.dart';
import 'base_auth_user_provider.dart' as auth_base;

class SupabaseAuthManager {
  SupabaseAuthManager._();
  static final SupabaseAuthManager instance = SupabaseAuthManager._();

  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  Future<AuthResponse> registerUser({
    required String email,
    required String fullName,
    required String password,
    required String confirmPassword,
  }) async {
    // Validações básicas de entrada
    if (email.trim().isEmpty || fullName.trim().isEmpty) {
      throw const AuthException('Campos obrigatórios ausentes.');
    }
    if (!_emailRegex.hasMatch(email.trim())) {
      throw const AuthException('E-mail inválido.');
    }
    if (password != confirmPassword) {
      throw const AuthException('Senha e confirmação não correspondem.');
    }
    if (password.length < 8) {
      throw const AuthException('A senha deve ter ao menos 8 caracteres.');
    }

    // Criação segura do usuário via Supabase Auth
    final client = SupaFlow.client;
    final response = await client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        'full_name': fullName.trim(),
      },
    );

    final user = response.user;
    if (user == null) {
      // Em cenários de confirmação por e-mail, user pode ser nulo
      // Não expor detalhes sensíveis; retorne o response para o chamador lidar.
      return response;
    }

    // Persistir dados mínimos em app_users conforme schema
    try {
      await AppUsersTable().insert({
        'id': user.id,
        'email': email.trim(),
        'full_name': fullName.trim(),
        'status': 'active',
        'created_at': DateTime.now().toUtc(),
        'updated_at': DateTime.now().toUtc(),
        'profile_complete': false,
      });
    } on PostgrestException {
      // Se já existe, prosseguir silenciosamente para evitar expor detalhes
    } catch (_) {
      // Evitar logs de dados sensíveis
    }

    return response;
  }
}

abstract class AuthManager {
  Future signOut();
  Future deleteUser(BuildContext context);
  Future updateEmail({required String email, required BuildContext context});
  Future resetPassword({required String email, required BuildContext context});
  Future sendEmailVerification() async => auth_base.currentUser?.sendEmailVerification();
  Future refreshUser() async => auth_base.currentUser?.refreshUser();
}

mixin EmailSignInManager on AuthManager {
  Future<auth_base.BaseAuthUser?> signInWithEmail(
    BuildContext context,
    String email,
    String password,
  );

  Future<auth_base.BaseAuthUser?> createAccountWithEmail(
    BuildContext context,
    String email,
    String password,
  );
}

mixin AnonymousSignInManager on AuthManager {
  Future<auth_base.BaseAuthUser?> signInAnonymously(BuildContext context);
}

mixin AppleSignInManager on AuthManager {
  Future<auth_base.BaseAuthUser?> signInWithApple(BuildContext context);
}

mixin GoogleSignInManager on AuthManager {
  Future<auth_base.BaseAuthUser?> signInWithGoogle(BuildContext context);
}

mixin JwtSignInManager on AuthManager {
  Future<auth_base.BaseAuthUser?> signInWithJwtToken(
    BuildContext context,
    String jwtToken,
  );
}

mixin PhoneSignInManager on AuthManager {
  Future beginPhoneAuth({
    required BuildContext context,
    required String phoneNumber,
    required void Function(BuildContext) onCodeSent,
  });

  Future verifySmsCode({
    required BuildContext context,
    required String smsCode,
  });
}

mixin FacebookSignInManager on AuthManager {
  Future<auth_base.BaseAuthUser?> signInWithFacebook(BuildContext context);
}

mixin MicrosoftSignInManager on AuthManager {
  Future<auth_base.BaseAuthUser?> signInWithMicrosoft(
    BuildContext context,
    List<String> scopes,
    String tenantId,
  );
}

mixin GithubSignInManager on AuthManager {
  Future<auth_base.BaseAuthUser?> signInWithGithub(BuildContext context);
}
