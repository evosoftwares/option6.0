// lib/infrastructure/repositories/supabase_backupappusersmigration_repository.dart
import '../../domain/entities/backupappusersmigration.dart';
import '../../domain/repositories/backupappusersmigration_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/backup_app_users_migration.dart';
import '../mappers/backupappusersmigration_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseBackupAppUsersMigrationRepository implements BackupAppUsersMigrationRepository {
  final BackupAppUsersMigrationTable _table;
  final BackupAppUsersMigrationMapper _mapper;
  
  SupabaseBackupAppUsersMigrationRepository({
    required BackupAppUsersMigrationTable table,
    required BackupAppUsersMigrationMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<BackupAppUsersMigration?>> findById(String id) async {
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
        RepositoryException('Failed to find backupappusersmigration: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<BackupAppUsersMigration>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all backupappusersmigrations: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(BackupAppUsersMigration backupappusersmigration) async {
    try {
      final data = _mapper.toSupabase(backupappusersmigration);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save backupappusersmigration: ${e.message}')
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
        RepositoryException('Failed to delete backupappusersmigration: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<BackupAppUsersMigration?>> findByUserId(String userId) async {
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
        RepositoryException('Failed to find backupappusersmigration by user ID: ${e.message}')
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

