// lib/domain/repositories/locationsharing_repository.dart
import '../entities/locationsharing.dart';
import '../value_objects/result.dart';


abstract class LocationSharingRepository {
  Future<Result<LocationSharing?>> findById(String id);
  Future<Result<List<LocationSharing>>> findAll();
  Future<Result<void>> save(LocationSharing locationsharing);
  Future<Result<void>> delete(String id);

  Future<Result<LocationSharing?>> findByUserId(String userId);
}
