// lib/infrastructure/repositories/supabase_savedplace_repository.dart
import '../../domain/entities/savedplace.dart';
import '../../domain/repositories/savedplace_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/saved_places.dart';
import '../mappers/savedplace_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseSavedPlaceRepository implements SavedPlaceRepository {
  final SavedPlacesTable _table;
  final SavedPlaceMapper _mapper;
  
  SupabaseSavedPlaceRepository({
    required SavedPlacesTable table,
    required SavedPlaceMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<SavedPlace?>> findById(String id) async {
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
        RepositoryException('Failed to find savedplace: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<SavedPlace>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all savedplaces: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(SavedPlace savedplace) async {
    try {
      final data = _mapper.toSupabase(savedplace);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save savedplace: ${e.message}')
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
        RepositoryException('Failed to delete savedplace: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<SavedPlace?>> findByUserId(String userId) async {
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
      return Result.failure(RepositoryException('Failed to find savedplace by user ID: ${e.message}'));
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

