// lib/infrastructure/repositories/supabase_tripstop_repository.dart
import '../../domain/entities/tripstop.dart';
import '../../domain/repositories/tripstop_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/trip_stops.dart';
import '../mappers/tripstop_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseTripStopRepository implements TripStopRepository {
  final TripStopsTable _table;
  final TripStopMapper _mapper;
  
  SupabaseTripStopRepository({
    required TripStopsTable table,
    required TripStopMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<TripStop?>> findById(String id) async {
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
        RepositoryException('Failed to find tripstop: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<TripStop>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all tripstops: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(TripStop tripstop) async {
    try {
      final data = _mapper.toSupabase(tripstop);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save tripstop: ${e.message}')
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
        RepositoryException('Failed to delete tripstop: ${e.message}')
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

