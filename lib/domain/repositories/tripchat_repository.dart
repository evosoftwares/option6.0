// lib/domain/repositories/tripchat_repository.dart
import '../entities/tripchat.dart';
import '../value_objects/result.dart';


abstract class TripChatRepository {
  Future<Result<TripChat?>> findById(String id);
  Future<Result<List<TripChat>>> findAll();
  Future<Result<void>> save(TripChat tripchat);
  Future<Result<void>> delete(String id);

}
