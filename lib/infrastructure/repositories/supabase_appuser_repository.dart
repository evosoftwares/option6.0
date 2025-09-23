// lib/infrastructure/repositories/supabase_appuser_repository.dart
import '../../domain/entities/appuser.dart';
import '../../domain/repositories/appuser_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/app_users.dart';
import '../mappers/appuser_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAppUserRepository implements AppUserRepository {
  final AppUsersTable _table;
  final AppUserMapper _mapper;
  
  SupabaseAppUserRepository({
    required AppUsersTable table,
    required AppUserMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<AppUser?>> findById(String id) async {
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
        RepositoryException('Failed to find appuser: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<AppUser>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all appusers: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(AppUser appuser) async {
    try {
      final data = _mapper.toSupabase(appuser);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save appuser: ${e.message}')
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
        RepositoryException('Failed to delete appuser: ${e.message}')
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

