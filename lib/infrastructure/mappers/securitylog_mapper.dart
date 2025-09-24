// lib/infrastructure/mappers/securitylog_mapper.dart
import '../../domain/entities/securitylog.dart';
import '../../backend/supabase/database/tables/security_logs.dart';


class SecurityLogMapper {
  SecurityLog toDomain(SecurityLogsRow row) {
    return SecurityLog(
      id: row.id,
      eventType: row.eventType ?? '',
      severity: row.severity ?? '',
      description: row.description ?? '',
      userId: row.userId ?? '',
      ipAddress: row.ipAddress ?? '',
      userAgent: row.userAgent ?? '',
      deviceInfo: row.deviceInfo ?? '',
      platform: row.platform ?? '',
      appVersion: row.appVersion ?? '',
      sessionId: row.sessionId ?? '',
      metadata: row.metadata,
      timestamp: row.timestamp ?? DateTime.now(),
      createdAt: row.createdAt ?? DateTime.now(),
    );
  }
  
  Map<String, dynamic> toSupabase(SecurityLog entity) {
    return {
      'id': entity.id,
      'event_type': entity.eventType,
      'severity': entity.severity,
      'description': entity.description,
      'user_id': entity.userId,
      'ip_address': entity.ipAddress,
      'user_agent': entity.userAgent,
      'device_info': entity.deviceInfo,
      'platform': entity.platform,
      'app_version': entity.appVersion,
      'session_id': entity.sessionId,
      'metadata': entity.metadata,
      'timestamp': entity.timestamp,
      'created_at': entity.createdAt,
    };
  }

}
