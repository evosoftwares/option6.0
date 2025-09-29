import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth_manager.dart' as base;
import '../base_auth_user_provider.dart' as auth_base;
import '../../backend/supabase/supabase.dart';

// Exporta tipos básicos utilizados no app
export '../base_auth_user_provider.dart' show loggedIn, BaseAuthUser;

// UID e e-mail do usuário atual (Supabase)
String get currentUserUid => SupaFlow.client.auth.currentUser?.id ?? '';
String get currentUserEmail => SupaFlow.client.auth.currentUser?.email ?? '';

// Mantém compatibilidade com backend.dart que ainda referencia currentUserDocument
Object? currentUserDocument;

/// Implementação de AuthManager baseada em Supabase.
class _SupabaseAuthManager implements base.AuthManager, base.EmailSignInManager {
  @override
  Future signOut() async {
    await SupaFlow.client.auth.signOut();
    auth_base.currentUser = _SupaAuthUser(null);
  }

  @override
  Future<auth_base.BaseAuthUser?> signInWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final res = await SupaFlow.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final wrapped = _SupaAuthUser(res.user);
      auth_base.currentUser = wrapped;
      return res.user != null ? wrapped : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<auth_base.BaseAuthUser?> createAccountWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final res = await SupaFlow.client.auth.signUp(
        email: email,
        password: password,
      );

      // Cria/atualiza o registro correspondente em app_users, garantindo consistência
      // Campos obrigatórios: id (não nulo). Mantemos email igual ao da autenticação.
      if (res.user != null) {
        try {
          await SupaFlow.client
              .from('app_users')
              .upsert({
                'id': res.user!.id,
                'email': res.user!.email,
              },
                  // Evita conflito em reenvio; usa id como chave de conflito
                  onConflict: 'id');
        } catch (e) {
          debugPrint('⚠️ Falha ao criar app_users para novo usuário: $e');
        }
      }
      final wrapped = _SupaAuthUser(res.user);
      auth_base.currentUser = wrapped;
      return res.user != null ? wrapped : null;
    } catch (_) {
      return null;
    }
  }

  // Métodos não utilizados neste fluxo podem permanecer não implementados
  @override
  Future deleteUser(BuildContext context) async {}
  @override
  Future updateEmail({required String email, required BuildContext context}) async {}
  @override
  Future resetPassword({required String email, required BuildContext context}) async {}
  @override
  Future refreshUser() async => auth_base.currentUser?.refreshUser();
  @override
  Future sendEmailVerification() async => auth_base.currentUser?.sendEmailVerification();
}

final _SupabaseAuthManager _authManager = _SupabaseAuthManager();
base.EmailSignInManager get authManager => _authManager;

// Wrapper de usuário Supabase para o contrato BaseAuthUser
class _SupaAuthUser extends auth_base.BaseAuthUser {
  _SupaAuthUser(this.user);
  final User? user;

  @override
  bool get loggedIn => user != null;

  @override
  bool get emailVerified => false;

  @override
  auth_base.AuthUserInfo get authUserInfo => auth_base.AuthUserInfo(
        uid: user?.id,
        email: user?.email,
        displayName: null,
        photoUrl: null,
        phoneNumber: null,
      );

  @override
  Future? delete() => null;

  @override
  Future? updateEmail(String email) => null;

  @override
  Future? updatePassword(String newPassword) => null;

  @override
  Future? sendEmailVerification() => null;

  @override
  Future refreshUser() async {}
}

// Streams baseadas em Supabase (mantendo nomes esperados pelo app)
Stream<auth_base.BaseAuthUser> optionFirebaseUserStream() {
  return SupaFlow.client.auth.onAuthStateChange.map((event) {
    final wrapped = _SupaAuthUser(event.session?.user);
    auth_base.currentUser = wrapped;
    return wrapped;
  });
}

Stream<auth_base.BaseAuthUser> authenticatedUserStream =
    optionFirebaseUserStream();

Stream<String?> jwtTokenStream = SupaFlow.client.auth.onAuthStateChange
    .map((event) => event.session?.accessToken);

// Função auxiliar pública para obter o usuário atual como BaseAuthUser
auth_base.BaseAuthUser supabaseCurrentAuthUser() =>
    _SupaAuthUser(SupaFlow.client.auth.currentUser);