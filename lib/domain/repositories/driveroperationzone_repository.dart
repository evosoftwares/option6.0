// lib/domain/repositories/driveroperationzone_repository.dart
import '../entities/driveroperationzone.dart';
import '../value_objects/result.dart';


abstract class DriverOperationZoneRepository {
  Future<Result<DriverOperationZone?>> findById(String id);
  Future<Result<List<DriverOperationZone>>> findAll();
  Future<Result<void>> save(DriverOperationZone driveroperationzone);
  Future<Result<void>> delete(String id);

}
