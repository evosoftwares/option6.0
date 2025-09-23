// lib/infrastructure/repositories/supabase_triprequest_repository.dart
import '../../domain/entities/triprequest.dart';
import '../../domain/repositories/triprequest_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/trip_requests.dart';
import '../mappers/triprequest_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseTripRequestRepository implements TripRequestRepository {
  final TripRequestsTable _table;
  final TripRequestMapper _mapper;
  
  SupabaseTripRequestRepository({
    required TripRequestsTable table,
    required TripRequestMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<TripRequest?>> findById(String id) async {
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
        RepositoryException('Failed to find triprequest: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<TripRequest>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all triprequests: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(TripRequest triprequest) async {
    try {
      final data = _mapper.toSupabase(triprequest);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save triprequest: ${e.message}')
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
        RepositoryException('Failed to delete triprequest: ${e.message}')
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

