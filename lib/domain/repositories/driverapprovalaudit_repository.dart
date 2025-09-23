// lib/domain/repositories/driverapprovalaudit_repository.dart
import '../entities/driverapprovalaudit.dart';
import '../value_objects/result.dart';


abstract class DriverApprovalAuditRepository {
  Future<Result<DriverApprovalAudit?>> findById(String id);
  Future<Result<List<DriverApprovalAudit>>> findAll();
  Future<Result<void>> save(DriverApprovalAudit driverapprovalaudit);
  Future<Result<void>> delete(String id);

}
