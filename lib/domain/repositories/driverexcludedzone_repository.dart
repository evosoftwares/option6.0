// lib/domain/repositories/driverexcludedzone_repository.dart
import '../entities/driverexcludedzone.dart';
import '../value_objects/result.dart';


abstract class DriverExcludedZoneRepository {
  Future<Result<DriverExcludedZone?>> findById(String id);
  Future<Result<List<DriverExcludedZone>>> findAll();
  Future<Result<void>> save(DriverExcludedZone driverexcludedzone);
  Future<Result<void>> delete(String id);

}
