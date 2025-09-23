// lib/domain/repositories/appusers_repository.dart
import '../entities/appusers.dart';
import '../value_objects/result.dart';


abstract class AppUsersRepository {
  Future<Result<AppUsers?>> findById(String id);
  Future<Result<List<AppUsers>>> findAll();
  Future<Result<void>> save(AppUsers appusers);
  Future<Result<void>> delete(String id);

}
