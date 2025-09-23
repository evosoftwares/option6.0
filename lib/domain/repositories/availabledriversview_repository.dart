// lib/domain/repositories/availabledriversview_repository.dart
import '../entities/availabledriversview.dart';
import '../value_objects/result.dart';

abstract class AvailableDriversViewRepository {
  Future<Result<AvailableDriversView?>> findById(String id);
  Future<Result<List<AvailableDriversView>>> findAll();
  Future<Result<void>> save(AvailableDriversView availabledriversview);
  Future<Result<void>> delete(String id);

  Future<Result<AvailableDriversView?>> findByUserId(String userId);
}
