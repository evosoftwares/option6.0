// lib/infrastructure/mappers/securityalert_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/securityalert.dart';
import '../../backend/supabase/database/tables/security_alerts.dart';


class SecurityAlertMapper {
  SecurityAlert toDomain(SecurityAlertsRow row) {
    return SecurityAlert(
      id: row.id,
      alertType: row.alertType,
      severity: row.severity,
      description: row.description,
      metadata: row.metadata,
      resolved: row.resolved,
      resolvedAt: row.resolvedAt,
      resolvedBy: row.resolvedBy,
      createdAt: row.createdAt,
    );
  }
  
  Map<String, dynamic> toSupabase(SecurityAlert entity) {
    return {
      'id': entity.id,
      'alert_type': entity.alertType,
      'severity': entity.severity,
      'description': entity.description,
      'metadata': entity.metadata,
      'resolved': entity.resolved,
      'resolved_at': entity.resolvedAt,
      'resolved_by': entity.resolvedBy,
      'created_at': entity.createdAt,
    };
  }

}
