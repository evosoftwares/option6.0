// lib/domain/repositories/backuppassengersbeforefkchange_repository.dart
import '../entities/backuppassengersbeforefkchange.dart';
import '../value_objects/result.dart';


abstract class BackupPassengersBeforeFkChangeRepository {
  Future<Result<BackupPassengersBeforeFkChange?>> findById(String id);
  Future<Result<List<BackupPassengersBeforeFkChange>>> findAll();
  Future<Result<void>> save(BackupPassengersBeforeFkChange backuppassengersbeforefkchange);
  Future<Result<void>> delete(String id);

  Future<Result<BackupPassengersBeforeFkChange?>> findByUserId(String userId);
}
