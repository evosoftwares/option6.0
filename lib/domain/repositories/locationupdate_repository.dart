// lib/domain/repositories/locationupdate_repository.dart
import '../entities/locationupdate.dart';
import '../value_objects/result.dart';

abstract class LocationUpdateRepository {
  Future<Result<LocationUpdate?>> findById(String id);
  Future<Result<List<LocationUpdate>>> findAll();
  Future<Result<void>> save(LocationUpdate locationupdate);
  Future<Result<void>> delete(String id);

}
