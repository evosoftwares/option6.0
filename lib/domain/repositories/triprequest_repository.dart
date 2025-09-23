// lib/domain/repositories/triprequest_repository.dart
import '../entities/triprequest.dart';
import '../value_objects/result.dart';

abstract class TripRequestRepository {
  Future<Result<TripRequest?>> findById(String id);
  Future<Result<List<TripRequest>>> findAll();
  Future<Result<void>> save(TripRequest triprequest);
  Future<Result<void>> delete(String id);

}
