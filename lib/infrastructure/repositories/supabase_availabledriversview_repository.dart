// lib/infrastructure/repositories/supabase_availabledriversview_repository.dart
import '../../domain/entities/availabledriversview.dart';
import '../../domain/repositories/availabledriversview_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/available_drivers_view.dart';
import '../mappers/availabledriversview_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseAvailableDriversViewRepository implements AvailableDriversViewRepository {
  final AvailableDriversViewTable _table;
  final AvailableDriversViewMapper _mapper;
  
  SupabaseAvailableDriversViewRepository({
    required AvailableDriversViewTable table,
    required AvailableDriversViewMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<AvailableDriversView?>> findById(String id) async {
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
        RepositoryException('Failed to find availabledriversview: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<AvailableDriversView>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all availabledriversviews: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(AvailableDriversView availabledriversview) async {
    try {
      final data = _mapper.toSupabase(availabledriversview);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save availabledriversview: ${e.message}')
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
        RepositoryException('Failed to delete availabledriversview: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<AvailableDriversView?>> findByUserId(String userId) async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q.eq('user_id', userId).limit(1),
      );
      if (rows.isEmpty) {
        return Result.success(null);
      }
      final entity = _mapper.toDomain(rows.first);
      return Result.success(entity);
    } on PostgrestException catch (e) {
      return Result.failure(RepositoryException('Failed to find availabledriversview by user ID: ${e.message}'));
    } catch (e) {
      return Result.failure(RepositoryException('Unexpected error: $e'));
    }
  }
}

class RepositoryException implements Exception {
  final String message;
  const RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}

