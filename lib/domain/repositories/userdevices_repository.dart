// lib/domain/repositories/userdevices_repository.dart
import '../entities/userdevices.dart';
import '../value_objects/result.dart';


abstract class UserDevicesRepository {
  Future<Result<UserDevices?>> findById(String id);
  Future<Result<List<UserDevices>>> findAll();
  Future<Result<void>> save(UserDevices userdevices);
  Future<Result<void>> delete(String id);

  Future<Result<UserDevices?>> findByUserId(String userId);
}
