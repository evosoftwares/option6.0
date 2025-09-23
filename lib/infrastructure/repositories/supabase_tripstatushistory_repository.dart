// lib/infrastructure/repositories/supabase_tripstatushistory_repository.dart
import '../../domain/entities/tripstatushistory.dart';
import '../../domain/repositories/tripstatushistory_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/trip_status_history.dart';
import '../mappers/tripstatushistory_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseTripStatusHistoryRepository implements TripStatusHistoryRepository {
  final TripStatusHistoryTable _table;
  final TripStatusHistoryMapper _mapper;
  
  SupabaseTripStatusHistoryRepository({
    required TripStatusHistoryTable table,
    required TripStatusHistoryMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<TripStatusHistory?>> findById(String id) async {
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
        RepositoryException('Failed to find tripstatushistory: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<TripStatusHistory>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all tripstatushistorys: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(TripStatusHistory tripstatushistory) async {
    try {
      final data = _mapper.toSupabase(tripstatushistory);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save tripstatushistory: ${e.message}')
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
        RepositoryException('Failed to delete tripstatushistory: ${e.message}')
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

