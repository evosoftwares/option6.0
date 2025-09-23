// lib/infrastructure/repositories/supabase_tripchat_repository.dart
import '../../domain/entities/tripchat.dart';
import '../../domain/repositories/tripchat_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/trip_chats.dart';
import '../mappers/tripchat_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseTripChatRepository implements TripChatRepository {
  final TripChatsTable _table;
  final TripChatMapper _mapper;
  
  SupabaseTripChatRepository({
    required TripChatsTable table,
    required TripChatMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<TripChat?>> findById(String id) async {
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
        RepositoryException('Failed to find tripchat: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<TripChat>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all tripchats: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(TripChat tripchat) async {
    try {
      final data = _mapper.toSupabase(tripchat);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save tripchat: ${e.message}')
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
        RepositoryException('Failed to delete tripchat: ${e.message}')
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

