// lib/domain/repositories/securityalert_repository.dart
import '../entities/securityalert.dart';
import '../value_objects/result.dart';


abstract class SecurityAlertRepository {
  Future<Result<SecurityAlert?>> findById(String id);
  Future<Result<List<SecurityAlert>>> findAll();
  Future<Result<void>> save(SecurityAlert securityalert);
  Future<Result<void>> delete(String id);

}
