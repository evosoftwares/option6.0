// lib/domain/repositories/driverstatu_repository.dart
import '../entities/driverstatu.dart';
import '../value_objects/result.dart';


abstract class DriverStatuRepository {
  Future<Result<DriverStatu?>> findById(String id);
  Future<Result<List<DriverStatu>>> findAll();
  Future<Result<void>> save(DriverStatu driverstatu);
  Future<Result<void>> delete(String id);

}
