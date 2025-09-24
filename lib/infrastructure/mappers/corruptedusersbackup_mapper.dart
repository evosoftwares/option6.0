// lib/infrastructure/mappers/corruptedusersbackup_mapper.dart
import '../../domain/entities/corruptedusersbackup.dart';
import '../../backend/supabase/database/tables/corrupted_users_backup.dart';


class CorruptedUsersBackupMapper {
  CorruptedUsersBackup toDomain(CorruptedUsersBackupRow row) {
    return CorruptedUsersBackup(
      id: row.id,
      originalUserId: row.originalUserId ?? '',
      originalFullName: row.originalFullName ?? '',
      originalPhone: row.originalPhone ?? '',
      originalEmail: row.originalEmail ?? '',
      correctionReason: row.correctionReason ?? '',
      restored: row.restored ?? false,
      restoredAt: row.restoredAt ?? DateTime.now(),
    );
  }
  
  Map<String, dynamic> toSupabase(CorruptedUsersBackup entity) {
    return {
      'id': entity.id,
      'original_user_id': entity.originalUserId,
      'original_full_name': entity.originalFullName,
      'original_phone': entity.originalPhone,
      'original_email': entity.originalEmail,
      'correction_reason': entity.correctionReason,
      'restored': entity.restored,
      'restored_at': entity.restoredAt,
    };
  }

}
