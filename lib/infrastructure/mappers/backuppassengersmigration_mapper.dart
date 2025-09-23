// lib/infrastructure/mappers/backuppassengersmigration_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/backuppassengersmigration.dart';
import '../../backend/supabase/database/tables/backup_passengers_migration.dart';


class BackupPassengersMigrationMapper {
  BackupPassengersMigration toDomain(BackupPassengersMigrationRow row) {
    return BackupPassengersMigration(
      id: row.id,
      userId: row.userId,
      totalTrips: row.totalTrips,
      averageRating: row.averageRating,
      paymentMethodId: row.paymentMethodId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
  
  Map<String, dynamic> toSupabase(BackupPassengersMigration entity) {
    return {
      'id': entity.id,
      'user_id': entity.userId,
      'total_trips': entity.totalTrips,
      'average_rating': entity.averageRating,
      'payment_method_id': entity.paymentMethodId,
      'created_at': entity.createdAt,
      'updated_at': entity.updatedAt,
    };
  }

}
