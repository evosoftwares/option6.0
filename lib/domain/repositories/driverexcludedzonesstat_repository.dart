// lib/domain/repositories/driverexcludedzonesstat_repository.dart
import '../entities/driverexcludedzonesstat.dart';
import '../value_objects/result.dart';


abstract class DriverExcludedZonesStatRepository {
  Future<Result<DriverExcludedZonesStat?>> findById(String id);
  Future<Result<List<DriverExcludedZonesStat>>> findAll();
  Future<Result<void>> save(DriverExcludedZonesStat driverexcludedzonesstat);
  Future<Result<void>> delete(String id);

}
