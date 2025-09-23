// lib/infrastructure/mappers/backupappusersmigration_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/backupappusersmigration.dart';
import '../../backend/supabase/database/tables/backup_app_users_migration.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/phone_number.dart';

class BackupAppUsersMigrationMapper {
  BackupAppUsersMigration toDomain(BackupAppUsersMigrationRow row) {
    return BackupAppUsersMigration(
      id: row.id,
      email: Email(row.email!),
      fullName: row.fullName,
      phone: PhoneNumber(row.phone!),
      photoUrl: row.photoUrl,
      userType: row.userType,
      status: row.status,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      userId: row.userId,
    );
  }
  
  Map<String, dynamic> toSupabase(BackupAppUsersMigration entity) {
    return {
      'id': entity.id,
      'email': entity.email.value,
      'full_name': entity.fullName,
      'phone': entity.phone.value,
      'photo_url': entity.photoUrl,
      'user_type': entity.userType,
      'status': entity.status,
      'created_at': entity.createdAt,
      'updated_at': entity.updatedAt,
      'user_id': entity.userId,
    };
  }

}
