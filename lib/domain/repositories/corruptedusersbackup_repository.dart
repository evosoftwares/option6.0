// lib/domain/repositories/corruptedusersbackup_repository.dart
import '../entities/corruptedusersbackup.dart';
import '../value_objects/result.dart';


abstract class CorruptedUsersBackupRepository {
  Future<Result<CorruptedUsersBackup?>> findById(String id);
  Future<Result<List<CorruptedUsersBackup>>> findAll();
  Future<Result<void>> save(CorruptedUsersBackup corruptedusersbackup);
  Future<Result<void>> delete(String id);

}
