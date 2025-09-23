// lib/infrastructure/repositories/supabase_backupdriversmigration_repository.dart
import '../../domain/entities/backupdriversmigration.dart';
import '../../domain/repositories/backupdriversmigration_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/backup_drivers_migration.dart';
import '../mappers/backupdriversmigration_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseBackupDriversMigrationRepository implements BackupDriversMigrationRepository {
  final BackupDriversMigrationTable _table;
  final BackupDriversMigrationMapper _mapper;
  
  SupabaseBackupDriversMigrationRepository({
    required BackupDriversMigrationTable table,
    required BackupDriversMigrationMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<BackupDriversMigration?>> findById(String id) async {
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
        RepositoryException('Failed to find backupdriversmigration: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<BackupDriversMigration>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all backupdriversmigrations: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(BackupDriversMigration backupdriversmigration) async {
    try {
      final data = _mapper.toSupabase(backupdriversmigration);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save backupdriversmigration: ${e.message}')
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
        RepositoryException('Failed to delete backupdriversmigration: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<BackupDriversMigration?>> findByUserId(String userId) async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q.eq('user_id', userId),
      );
      
      if (rows.isEmpty) {
        return Result.success(null);
      }
      
      final entity = _mapper.toDomain(rows.first);
      return Result.success(entity);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find backupdriversmigration by user ID: ${e.message}')
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

