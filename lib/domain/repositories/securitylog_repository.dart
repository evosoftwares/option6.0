// lib/domain/repositories/securitylog_repository.dart
import '../entities/securitylog.dart';
import '../value_objects/result.dart';


abstract class SecurityLogRepository {
  Future<Result<SecurityLog?>> findById(String id);
  Future<Result<List<SecurityLog>>> findAll();
  Future<Result<void>> save(SecurityLog securitylog);
  Future<Result<void>> delete(String id);

  Future<Result<SecurityLog?>> findByUserId(String userId);
}
