// lib/infrastructure/repositories/supabase_locationupdate_repository.dart
import '../../domain/entities/locationupdate.dart';
import '../../domain/repositories/locationupdate_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/location_updates.dart';
import '../mappers/locationupdate_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseLocationUpdateRepository implements LocationUpdateRepository {
  final LocationUpdatesTable _table;
  final LocationUpdateMapper _mapper;
  
  SupabaseLocationUpdateRepository({
    required LocationUpdatesTable table,
    required LocationUpdateMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<LocationUpdate?>> findById(String id) async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q.eq('id', id),
      );
      if (rows.isEmpty) {
        return Result.success(null);
      }
      final update = _mapper.toDomain(rows.first);
      return Result.success(update);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find LocationUpdate by id: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<LocationUpdate>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all locationupdates: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(LocationUpdate locationupdate) async {
    try {
      final data = _mapper.toSupabase(locationupdate);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save locationupdate: ${e.message}')
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
        RepositoryException('Failed to delete locationupdate: ${e.message}')
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
