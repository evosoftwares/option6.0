// lib/domain/repositories/backupconflict409removal_repository.dart
import '../entities/backupconflict409removal.dart';
import '../value_objects/result.dart';


abstract class BackupConflict409RemovalRepository {
  Future<Result<BackupConflict409Removal?>> findById(String id);
  Future<Result<List<BackupConflict409Removal>>> findAll();
  Future<Result<void>> save(BackupConflict409Removal backupconflict409removal);
  Future<Result<void>> delete(String id);

}
