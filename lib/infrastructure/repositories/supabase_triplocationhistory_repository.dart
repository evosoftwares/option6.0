// lib/infrastructure/repositories/supabase_triplocationhistory_repository.dart
import '../../domain/entities/triplocationhistory.dart';
import '../../domain/repositories/triplocationhistory_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/trip_location_history.dart';
import '../mappers/triplocationhistory_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseTripLocationHistoryRepository implements TripLocationHistoryRepository {
  final TripLocationHistoryTable _table;
  final TripLocationHistoryMapper _mapper;
  
  SupabaseTripLocationHistoryRepository({
    required TripLocationHistoryTable table,
    required TripLocationHistoryMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<TripLocationHistory?>> findById(String id) async {
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
        RepositoryException('Failed to find triplocationhistory: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<TripLocationHistory>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all triplocationhistorys: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(TripLocationHistory triplocationhistory) async {
    try {
      final data = _mapper.toSupabase(triplocationhistory);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save triplocationhistory: ${e.message}')
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
        RepositoryException('Failed to delete triplocationhistory: ${e.message}')
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

