import '/backend/supabase/supabase.dart';
// lib/flutter_flow/user_id_converter.dart
import '../backend/supabase/database/tables/app_users.dart';

/// Helper class para conversão entre Firebase UID e Supabase UUID
class UserIdConverter {
  /// Converte Firebase UID para app_users.id (UUID)
  /// 
  /// Busca o usuário na tabela app_users usando o fcm_token (que armazena o Firebase UID)
  /// e retorna o UUID correspondente.
  /// 
  /// Returns null se o usuário não for encontrado.
  static Future<String?> getAppUserIdFromFirebaseUid(String firebaseUid) async {
    try {
      final query = await AppUsersTable().queryRows(
        queryFn: (q) => q.eq('fcm_token', firebaseUid).limit(1),
      );
      
      if (query.isNotEmpty) {
        final appUserId = query.first.id;
        print('🔄 [UserIdConverter] Firebase UID "$firebaseUid" -> App User ID "$appUserId"');
        return appUserId;
      } else {
        print('⚠️ [UserIdConverter] Usuário não encontrado para Firebase UID: $firebaseUid');
        return null;
      }
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
        final firebaseUid = query.first.fcmToken;
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
    // UUID pattern: 8-4-4-4-12 characters separated by hyphens
    final uuidPattern = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', caseSensitive: false);
    
    if (uuidPattern.hasMatch(id)) {
      return false; // É UUID
    }
    
    // Firebase UID geralmente tem 28 caracteres alfanuméricos
    return id.length >= 20 && id.length <= 30 && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(id);
  }
}
