// lib/domain/repositories/savedplace_repository.dart
import '../entities/savedplace.dart';
import '../value_objects/result.dart';

abstract class SavedPlaceRepository {
  Future<Result<SavedPlace?>> findById(String id);
  Future<Result<List<SavedPlace>>> findAll();
  Future<Result<void>> save(SavedPlace savedplace);
  Future<Result<void>> delete(String id);

  Future<Result<SavedPlace?>> findByUserId(String userId);
}
