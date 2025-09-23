// lib/domain/repositories/backupdriversmigration_repository.dart
import '../entities/backupdriversmigration.dart';
import '../value_objects/result.dart';

abstract class BackupDriversMigrationRepository {
  Future<Result<BackupDriversMigration?>> findById(String id);
  Future<Result<List<BackupDriversMigration>>> findAll();
  Future<Result<void>> save(BackupDriversMigration backupdriversmigration);
  Future<Result<void>> delete(String id);

  Future<Result<BackupDriversMigration?>> findByUserId(String userId);
}
