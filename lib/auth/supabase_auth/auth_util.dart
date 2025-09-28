import 'package:flutter/material.dart';
import '/backend/supabase/supabase.dart';
import '/backend/supabase/database/database.dart';

export '/backend/supabase/auth/supabase_auth_manager.dart';
export '/backend/supabase/auth/supabase_user_provider.dart';

final _authManager = SupabaseAuthManager.instance;
SupabaseAuthManager get authManager => _authManager;

String get currentUserEmail => currentUser?.email ?? '';

String get currentUserUid => currentUser?.uid ?? '';

String get currentUserDisplayName => currentUser?.displayName ?? '';

String get currentUserPhoto => currentUser?.photoUrl ?? '';

String get currentPhoneNumber => currentUser?.phoneNumber ?? '';

String get currentJwtToken => _currentJwtToken ?? '';

bool get currentUserEmailVerified => currentUser?.emailVerified ?? false;

bool get loggedIn => currentUser != null;

/// Create a Stream that listens to the current user's JWT Token from Supabase
String? _currentJwtToken;
final jwtTokenStream = SupaFlow.client.auth.onAuthStateChange
    .asyncMap((data) async {
      try {
        _currentJwtToken = data.session?.accessToken;
      } catch (e) {
        // Network errors can happen (offline, DNS, etc.). Keep last known token.
        debugPrint('⚠️ [SUPABASE_AUTH] Falha ao obter JWT: $e');
      }
      return _currentJwtToken;
    })
    .handleError((e, __) {
      // Ensure no unhandled errors propagate from this stream
      debugPrint('⚠️ [SUPABASE_AUTH] Erro no stream de JWT: $e');
    })
    .asBroadcastStream();

/// Stream que monitora mudanças no usuário autenticado do Supabase
AppUsersRow? currentUserDocument;
final authenticatedUserStream = SupaFlow.client.auth.onAuthStateChange
    .map((data) => data.session?.user.id ?? '')
    .asyncMap((uid) async {
      if (uid.isEmpty) {
        currentUserDocument = null;
        return null;
      }
      
      try {
        final rows = await AppUsersTable().queryRows(
          queryFn: (q) => q.eq('id', uid).limit(1),
        );
        currentUserDocument = rows.isNotEmpty ? rows.first : null;
        return currentUserDocument;
      } catch (e) {
        debugPrint('❌ [SUPABASE_AUTH] Erro ao buscar documento do usuário: $e');
        return null;
      }
    })
    .handleError((e, __) {
      debugPrint('⚠️ [SUPABASE_AUTH] Erro no stream de usuário: $e');
    })
    .asBroadcastStream();

class AuthUserStreamWidget extends StatelessWidget {
  const AuthUserStreamWidget({Key? key, required this.builder})
      : super(key: key);

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: authenticatedUserStream,
        builder: (context, _) => builder(context),
      );
}

/// Inicializa o sistema de autenticação Supabase
Future<void> initializeSupabaseAuth() async {
  try {
    authManager.initialize();
    debugPrint('✅ [SUPABASE_AUTH] Sistema de autenticação inicializado');
  } catch (e) {
    debugPrint('❌ [SUPABASE_AUTH] Erro na inicialização: $e');
  }
}

/// Função para sincronizar usuário com a tabela app_users do Supabase
Future<void> syncUserWithSupabase(User user) async {
  try {
    final response = await SupaFlow.client
        .from('app_users')
        .select('id')
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) {
      // Usuário não existe, criar novo registro
      await SupaFlow.client.from('app_users').insert({
        'id': user.id,
        'email': user.email,
        'full_name': user.userMetadata?['display_name'] ?? user.email?.split('@').first,
        'phone': user.phone,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
      debugPrint('✅ [SUPABASE_AUTH] Usuário criado na tabela app_users');
    } else {
      // Usuário existe, atualizar dados se necessário
      await SupaFlow.client.from('app_users').update({
        'email': user.email,
        'phone': user.phone,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', user.id);
      debugPrint('✅ [SUPABASE_AUTH] Usuário atualizado na tabela app_users');
    }
  } catch (e) {
    debugPrint('❌ [SUPABASE_AUTH] Erro ao sincronizar usuário: $e');
  }
}

/// Função para obter referência do usuário atual (compatibilidade)
String? get currentUserReference => loggedIn ? currentUserUid : null;