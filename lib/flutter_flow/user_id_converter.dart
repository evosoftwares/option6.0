import '/backend/supabase/supabase.dart';
// lib/flutter_flow/user_id_converter.dart
import '../backend/supabase/database/tables/app_users.dart';

/// Helper class para conversão entre Firebase UID e Supabase UUID
class UserIdConverter {
  /// Converte Firebase UID para app_users.id (UUID)
  /// 
  /// Busca o usuário na tabela app_users usando primeiramente o fcm_token (que
  /// armazena o Firebase UID) e, em fallback, o campo currentUser_UID_Firebase.
  /// Retorna o UUID correspondente ou null se não encontrado.
  static Future<String?> getAppUserIdFromFirebaseUid(String firebaseUid) async {
    try {
      // 1) Tenta via fcm_token
      final byFcm = await AppUsersTable().queryRows(
        queryFn: (q) => q.eq('fcm_token', firebaseUid).limit(1),
      );
      if (byFcm.isNotEmpty) {
        final appUserId = byFcm.first.id;
        print('🔄 [UserIdConverter] Firebase UID "$firebaseUid" -> App User ID "$appUserId" (via fcm_token)');
        return appUserId;
      }

      // 2) Fallback via currentUser_UID_Firebase
      final byCurrentUid = await AppUsersTable().queryRows(
        queryFn: (q) => q.eq('currentUser_UID_Firebase', firebaseUid).limit(1),
      );
      if (byCurrentUid.isNotEmpty) {
        final appUserId = byCurrentUid.first.id;
        print('🔄 [UserIdConverter] Firebase UID "$firebaseUid" -> App User ID "$appUserId" (via currentUser_UID_Firebase)');
        return appUserId;
      }

      print('⚠️ [UserIdConverter] Usuário não encontrado para Firebase UID: $firebaseUid');
      return null;
    } catch (e) {
      print('❌ [UserIdConverter] Erro na conversão: $e');
      return null;
    }
  }
  
  /// Converte app_users.id (UUID) para Firebase UID
  /// 
  /// Busca o usuário na tabela app_users pelo ID e retorna o fcm_token (Firebase UID).
  /// 
  /// Returns null se o usuário não for encontrado.
  static Future<String?> getFirebaseUidFromAppUserId(String appUserId) async {
    try {
      final query = await AppUsersTable().queryRows(
        queryFn: (q) => q.eq('id', appUserId).limit(1),
      );
      
      if (query.isNotEmpty) {
        final firebaseUid = query.first.fcmToken ?? query.first.currentUserUidFirebase;
        print('🔄 [UserIdConverter] App User ID "$appUserId" -> Firebase UID "$firebaseUid"');
        return firebaseUid;
      } else {
        print('⚠️ [UserIdConverter] Usuário não encontrado para App User ID: $appUserId');
        return null;
      }
    } catch (e) {
      print('❌ [UserIdConverter] Erro na conversão: $e');
      return null;
    }
  }
  
  /// Verifica se um ID é um Firebase UID (string) ou UUID do Supabase
  /// 
  /// Firebase UIDs geralmente têm 28 caracteres e contêm letras e números
  /// UUIDs têm 36 caracteres com hífens no formato: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
  static bool isFirebaseUid(String id) {
    // UUID pattern: 8-4-4-4-12 caracteres separados por hífens
    final uuidPattern = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', caseSensitive: false);
    
    if (uuidPattern.hasMatch(id)) {
      return false; // É UUID
    }
    
    // Firebase UID geralmente tem 28 caracteres alfanuméricos
    return id.length >= 20 && id.length <= 30 && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(id);
  }
}
