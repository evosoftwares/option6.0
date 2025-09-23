// lib/domain/repositories/tripstop_repository.dart
import '../entities/tripstop.dart';
import '../value_objects/result.dart';

abstract class TripStopRepository {
  Future<Result<TripStop?>> findById(String id);
  Future<Result<List<TripStop>>> findAll();
  Future<Result<void>> save(TripStop tripstop);
  Future<Result<void>> delete(String id);

}
