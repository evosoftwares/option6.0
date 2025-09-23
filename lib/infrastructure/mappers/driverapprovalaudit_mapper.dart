// lib/infrastructure/mappers/driverapprovalaudit_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/driverapprovalaudit.dart';
import '../../backend/supabase/database/tables/driver_approval_audit.dart';


class DriverApprovalAuditMapper {
  DriverApprovalAudit toDomain(DriverApprovalAuditRow row) {
    return DriverApprovalAudit(
      id: row.id,
      driverId: row.driverId,
      oldStatus: row.oldStatus,
      newStatus: row.newStatus,
      reason: row.reason,
      approvedDocuments: row.approvedDocuments,
      createdAt: row.createdAt,
    );
  }
  
  Map<String, dynamic> toSupabase(DriverApprovalAudit entity) {
    return {
      'id': entity.id,
      'driver_id': entity.driverId,
      'old_status': entity.oldStatus,
      'new_status': entity.newStatus,
      'reason': entity.reason,
      'approved_documents': entity.approvedDocuments,
      'created_at': entity.createdAt,
    };
  }

}
