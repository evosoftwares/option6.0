// lib/domain/repositories/userdevice_repository.dart
import '../entities/userdevice.dart';
import '../value_objects/result.dart';

abstract class UserDeviceRepository {
  Future<Result<UserDevice?>> findById(String id);
  Future<Result<List<UserDevice>>> findAll();
  Future<Result<void>> save(UserDevice userdevice);
  Future<Result<void>> delete(String id);

  Future<Result<UserDevice?>> findByUserId(String userId);
}
