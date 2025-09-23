// lib/domain/repositories/driver_repository.dart
import '../entities/driver.dart';
import '../value_objects/result.dart';
import '../value_objects/location.dart';

abstract class DriverRepository {
  Future<Result<Driver?>> findById(String id);
  Future<Result<List<Driver>>> findAll();
  Future<Result<void>> save(Driver driver);
  Future<Result<void>> delete(String id);

  Future<Result<Driver?>> findByUserId(String userId);
  Future<Result<List<Driver>>> findAvailableInRadius(Location center, Distance radius);
  Future<Result<void>> updateOnlineStatus(String driverId, bool isOnline);
  Future<Result<void>> updateLocation(String driverId, Location location);
}
