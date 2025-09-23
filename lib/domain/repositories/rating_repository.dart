// lib/domain/repositories/rating_repository.dart
import '../entities/rating.dart';
import '../value_objects/result.dart';


abstract class RatingRepository {
  Future<Result<Rating?>> findById(String id);
  Future<Result<List<Rating>>> findAll();
  Future<Result<void>> save(Rating rating);
  Future<Result<void>> delete(String id);

}
