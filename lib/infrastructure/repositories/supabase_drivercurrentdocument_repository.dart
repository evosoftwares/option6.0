// lib/infrastructure/repositories/supabase_drivercurrentdocument_repository.dart
import '../../domain/entities/drivercurrentdocument.dart';
import '../../domain/repositories/drivercurrentdocument_repository.dart';
import '../../domain/value_objects/result.dart';
import '/backend/supabase/supabase.dart';
import '../mappers/drivercurrentdocument_mapper.dart';


class SupabaseDriverCurrentDocumentRepository implements DriverCurrentDocumentRepository {
  final DriverDocumentsTable _table;
  final DriverCurrentDocumentMapper _mapper;
  
  SupabaseDriverCurrentDocumentRepository({
    required DriverDocumentsTable table,
    required DriverCurrentDocumentMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<DriverCurrentDocument?>> findById(String id) async {
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
        RepositoryException('Failed to find drivercurrentdocument: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<DriverCurrentDocument>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final List<DriverCurrentDocument> entities =
          rows.map<DriverCurrentDocument>(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all drivercurrentdocuments: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(DriverCurrentDocument drivercurrentdocument) async {
    try {
      final data = _mapper.toSupabase(drivercurrentdocument);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save drivercurrentdocument: ${e.message}')
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
        RepositoryException('Failed to delete drivercurrentdocument: ${e.message}')
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

