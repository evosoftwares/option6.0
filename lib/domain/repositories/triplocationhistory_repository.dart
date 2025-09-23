// lib/domain/repositories/triplocationhistory_repository.dart
import '../entities/triplocationhistory.dart';
import '../value_objects/result.dart';

abstract class TripLocationHistoryRepository {
  Future<Result<TripLocationHistory?>> findById(String id);
  Future<Result<List<TripLocationHistory>>> findAll();
  Future<Result<void>> save(TripLocationHistory triplocationhistory);
  Future<Result<void>> delete(String id);

}
