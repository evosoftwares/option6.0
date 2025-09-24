// lib/infrastructure/mappers/tripstatushistory_mapper.dart
import '../../domain/entities/tripstatushistory.dart';
import '../../backend/supabase/database/tables/trip_status_history.dart';


class TripStatusHistoryMapper {
  TripStatusHistory toDomain(TripStatusHistoryRow row) {
    return TripStatusHistory(
      id: row.id,
      tripId: row.tripId ?? '',
      oldStatus: row.oldStatus ?? '',
      newStatus: row.newStatus ?? '',
      changedBy: row.changedBy ?? '',
      reason: row.reason ?? '',
      metadata: row.metadata,
      createdAt: row.createdAt ?? DateTime.now(),
    );
  }
  
  Map<String, dynamic> toSupabase(TripStatusHistory entity) {
    return {
      'id': entity.id,
      'trip_id': entity.tripId,
      'old_status': entity.oldStatus,
      'new_status': entity.newStatus,
      'changed_by': entity.changedBy,
      'reason': entity.reason,
      'metadata': entity.metadata,
      'created_at': entity.createdAt,
    };
  }

}
