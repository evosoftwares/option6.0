// lib/domain/repositories/backupappusersmigration_repository.dart
import '../entities/backupappusersmigration.dart';
import '../value_objects/result.dart';


abstract class BackupAppUsersMigrationRepository {
  Future<Result<BackupAppUsersMigration?>> findById(String id);
  Future<Result<List<BackupAppUsersMigration>>> findAll();
  Future<Result<void>> save(BackupAppUsersMigration backupappusersmigration);
  Future<Result<void>> delete(String id);

  Future<Result<BackupAppUsersMigration?>> findByUserId(String userId);
}
