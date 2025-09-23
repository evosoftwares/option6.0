// lib/domain/repositories/tripstatushistory_repository.dart
import '../entities/tripstatushistory.dart';
import '../value_objects/result.dart';


abstract class TripStatusHistoryRepository {
  Future<Result<TripStatusHistory?>> findById(String id);
  Future<Result<List<TripStatusHistory>>> findAll();
  Future<Result<void>> save(TripStatusHistory tripstatushistory);
  Future<Result<void>> delete(String id);

}
