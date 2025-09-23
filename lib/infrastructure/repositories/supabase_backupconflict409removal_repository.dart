// lib/infrastructure/repositories/supabase_backupconflict409removal_repository.dart
import '../../domain/entities/backupconflict409removal.dart';
import '../../domain/repositories/backupconflict409removal_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/backup_conflict_409_removal.dart';
import '../mappers/backupconflict409removal_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseBackupConflict409RemovalRepository implements BackupConflict409RemovalRepository {
  final BackupConflict409RemovalTable _table;
  final BackupConflict409RemovalMapper _mapper;
  
  SupabaseBackupConflict409RemovalRepository({
    required BackupConflict409RemovalTable table,
    required BackupConflict409RemovalMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<BackupConflict409Removal?>> findById(String id) async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q.eq('id', id),
      );
      
      if (rows.isEmpty) {
        return Result.success(null);
      }
      
      final entity = _mapper.toDomain(rows.first);
      return Result.success(entity);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find backupconflict409removal: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<BackupConflict409Removal>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all backupconflict409removals: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(BackupConflict409Removal backupconflict409removal) async {
    try {
      final data = _mapper.toSupabase(backupconflict409removal);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save backupconflict409removal: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _table.delete(
        matchingRows: (rows) => rows.eq('id', id),
      );
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to delete backupconflict409removal: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

}

class RepositoryException implements Exception {
  final String message;
  const RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}

