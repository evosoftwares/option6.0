// lib/infrastructure/repositories/supabase_securityalert_repository.dart
import '../../domain/entities/securityalert.dart';
import '../../domain/repositories/securityalert_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/security_alerts.dart';
import '../mappers/securityalert_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseSecurityAlertRepository implements SecurityAlertRepository {
  final SecurityAlertsTable _table;
  final SecurityAlertMapper _mapper;
  
  SupabaseSecurityAlertRepository({
    required SecurityAlertsTable table,
    required SecurityAlertMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<SecurityAlert?>> findById(String id) async {
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
        RepositoryException('Failed to find securityalert: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<SecurityAlert>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all securityalerts: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(SecurityAlert securityalert) async {
    try {
      final data = _mapper.toSupabase(securityalert);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save securityalert: ${e.message}')
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
        RepositoryException('Failed to delete securityalert: ${e.message}')
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

