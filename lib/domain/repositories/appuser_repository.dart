// lib/domain/repositories/appuser_repository.dart
import '../entities/appuser.dart';
import '../value_objects/result.dart';

abstract class AppUserRepository {
  Future<Result<AppUser?>> findById(String id);
  Future<Result<List<AppUser>>> findAll();
  Future<Result<void>> save(AppUser appuser);
  Future<Result<void>> delete(String id);

}
