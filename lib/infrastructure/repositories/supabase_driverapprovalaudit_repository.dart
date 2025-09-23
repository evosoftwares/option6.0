// lib/infrastructure/repositories/supabase_driverapprovalaudit_repository.dart
import '../../domain/entities/driverapprovalaudit.dart';
import '../../domain/repositories/driverapprovalaudit_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/driver_approval_audit.dart';
import '../mappers/driverapprovalaudit_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseDriverApprovalAuditRepository implements DriverApprovalAuditRepository {
  final DriverApprovalAuditTable _table;
  final DriverApprovalAuditMapper _mapper;
  
  SupabaseDriverApprovalAuditRepository({
    required DriverApprovalAuditTable table,
    required DriverApprovalAuditMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<DriverApprovalAudit?>> findById(String id) async {
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
        RepositoryException('Failed to find driverapprovalaudit: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<DriverApprovalAudit>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all driverapprovalaudits: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(DriverApprovalAudit driverapprovalaudit) async {
    try {
      final data = _mapper.toSupabase(driverapprovalaudit);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save driverapprovalaudit: ${e.message}')
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
        RepositoryException('Failed to delete driverapprovalaudit: ${e.message}')
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

