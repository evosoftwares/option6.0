import '/backend/supabase/supabase.dart';
// lib/flutter_flow/user_id_converter.dart
import '../backend/supabase/database/tables/app_users.dart';

/// Helper class para conversão entre Supabase UID e app_users.id (UUID)
class UserIdConverter {
  /// Converte Supabase UID para app_users.id (UUID)
  /// 
  /// Busca o usuário na tabela app_users usando o campo
  /// currentUser_UID_Firebase (que agora armazena o Supabase UID).
  /// Retorna o UUID correspondente ou null se não encontrado.
  static Future<String?> getAppUserIdFromSupabaseUid(String supabaseUid) async {
    try {
      // Busca por currentUser_UID_Firebase (que agora contém Supabase UID)
      final byCurrentUid = await AppUsersTable().queryRows(
        queryFn: (q) => q.eq('currentUser_UID_Firebase', supabaseUid).limit(1),
      );
      if (byCurrentUid.isNotEmpty) {
        final appUserId = byCurrentUid.first.id;
        print('🔄 [UserIdConverter] Supabase UID "$supabaseUid" -> App User ID "$appUserId"');
        return appUserId;
      }

      print('⚠️ [UserIdConverter] Supabase UID "$supabaseUid" não encontrado na tabela app_users');
      return null;
    } catch (e) {
      print('❌ [UserIdConverter] Erro ao converter Supabase UID "$supabaseUid": $e');
      return null;
    }
  }


}
