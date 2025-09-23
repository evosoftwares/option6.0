// lib/domain/repositories/backuppassengersmigration_repository.dart
import '../entities/backuppassengersmigration.dart';
import '../value_objects/result.dart';


abstract class BackupPassengersMigrationRepository {
  Future<Result<BackupPassengersMigration?>> findById(String id);
  Future<Result<List<BackupPassengersMigration>>> findAll();
  Future<Result<void>> save(BackupPassengersMigration backuppassengersmigration);
  Future<Result<void>> delete(String id);

  Future<Result<BackupPassengersMigration?>> findByUserId(String userId);
}
