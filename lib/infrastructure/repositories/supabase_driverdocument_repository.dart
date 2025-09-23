// lib/infrastructure/repositories/supabase_driverdocument_repository.dart
import '../../domain/entities/driverdocument.dart';
import '../../domain/repositories/driverdocument_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/driver_documents.dart';
import '../mappers/driverdocument_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseDriverDocumentRepository implements DriverDocumentRepository {
  final DriverDocumentsTable _table;
  final DriverDocumentMapper _mapper;
  
  SupabaseDriverDocumentRepository({
    required DriverDocumentsTable table,
    required DriverDocumentMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<DriverDocument?>> findById(String id) async {
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
        RepositoryException('Failed to find driverdocument: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<DriverDocument>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all driverdocuments: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(DriverDocument driverdocument) async {
    try {
      final data = _mapper.toSupabase(driverdocument);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save driverdocument: ${e.message}')
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
        RepositoryException('Failed to delete driverdocument: ${e.message}')
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

