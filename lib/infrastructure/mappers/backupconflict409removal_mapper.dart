// lib/infrastructure/mappers/backupconflict409removal_mapper.dart
import '../../domain/entities/backupconflict409removal.dart';
import '../../backend/supabase/database/tables/backup_conflict_409_removal.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/phone_number.dart';

class BackupConflict409RemovalMapper {
  BackupConflict409Removal toDomain(BackupConflict409RemovalRow row) {
    return BackupConflict409Removal(
      sourceTable: row.sourceTable ?? '',
      backupTimestamp: row.backupTimestamp ?? DateTime.now(),
      id: row.id,
      email: Email(row.email ?? ''),
      fullName: row.fullName ?? '',
      phone: PhoneNumber(row.phone ?? ''),
      photoUrl: row.photoUrl ?? '',
      userType: row.userType ?? '',
      status: row.status ?? '',
      createdAt: row.createdAt ?? DateTime.now(),
      updatedAt: row.updatedAt ?? DateTime.now(),
    );
  }
  
  Map<String, dynamic> toSupabase(BackupConflict409Removal entity) {
    return {
      'source_table': entity.sourceTable,
      'backup_timestamp': entity.backupTimestamp,
      'id': entity.id,
      'email': entity.email.value,
      'full_name': entity.fullName,
      'phone': entity.phone.value,
      'photo_url': entity.photoUrl,
      'user_type': entity.userType,
      'status': entity.status,
      'created_at': entity.createdAt,
      'updated_at': entity.updatedAt,
    };
  }

}
