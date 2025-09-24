// lib/infrastructure/mappers/backuppassengersbeforefkchange_mapper.dart
import '../../domain/entities/backuppassengersbeforefkchange.dart';
import '../../backend/supabase/database/tables/backup_passengers_before_fk_change.dart';


class BackupPassengersBeforeFkChangeMapper {
  BackupPassengersBeforeFkChange toDomain(BackupPassengersBeforeFkChangeRow row) {
    return BackupPassengersBeforeFkChange(
      id: row.id,
      totalTrips: row.totalTrips ?? 0,
      averageRating: row.averageRating ?? 0.0,
      paymentMethodId: row.paymentMethodId ?? '',
      createdAt: row.createdAt ?? DateTime.now(),
      updatedAt: row.updatedAt ?? DateTime.now(),
      userId: row.userId ?? '',
    );
  }
  
  Map<String, dynamic> toSupabase(BackupPassengersBeforeFkChange entity) {
    return {
      'id': entity.id,
      'total_trips': entity.totalTrips,
      'average_rating': entity.averageRating,
      'payment_method_id': entity.paymentMethodId,
      'created_at': entity.createdAt,
      'updated_at': entity.updatedAt,
      'user_id': entity.userId,
    };
  }

}
