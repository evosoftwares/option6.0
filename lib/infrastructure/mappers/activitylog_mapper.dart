// lib/infrastructure/mappers/activitylog_mapper.dart
import '../../domain/entities/activitylog.dart';
import '../../backend/supabase/database/tables/activity_logs.dart';


class ActivityLogMapper {
  ActivityLog toDomain(ActivityLogsRow row) {
    return ActivityLog(
      id: row.id,
      userId: row.userId ?? '',
      action: row.action ?? '',
      entityType: row.entityType ?? '',
      entityId: row.entityId ?? '',
      oldValues: row.oldValues,
      newValues: row.newValues,
      metadata: row.metadata,
      ipAddress: row.ipAddress ?? '',
      userAgent: row.userAgent ?? '',
      createdAt: row.createdAt ?? DateTime.now(),
    );
  }
  
  Map<String, dynamic> toSupabase(ActivityLog entity) {
    return {
      'id': entity.id,
      'user_id': entity.userId,
      'action': entity.action,
      'entity_type': entity.entityType,
      'entity_id': entity.entityId,
      'old_values': entity.oldValues,
      'new_values': entity.newValues,
      'metadata': entity.metadata,
      'ip_address': entity.ipAddress,
      'user_agent': entity.userAgent,
      'created_at': entity.createdAt,
    };
  }

}
