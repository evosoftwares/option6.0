// lib/infrastructure/repositories/supabase_driverexcludedzone_repository.dart
import '../../domain/entities/driverexcludedzone.dart';
import '../../domain/repositories/driverexcludedzone_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/driver_excluded_zones.dart';
import '../mappers/driverexcludedzone_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseDriverExcludedZoneRepository implements DriverExcludedZoneRepository {
  final DriverExcludedZonesTable _table;
  final DriverExcludedZoneMapper _mapper;
  
  SupabaseDriverExcludedZoneRepository({
    required DriverExcludedZonesTable table,
    required DriverExcludedZoneMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<DriverExcludedZone?>> findById(String id) async {
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
        RepositoryException('Failed to find driverexcludedzone: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<DriverExcludedZone>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all driverexcludedzones: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(DriverExcludedZone driverexcludedzone) async {
    try {
      final data = _mapper.toSupabase(driverexcludedzone);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save driverexcludedzone: ${e.message}')
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
        RepositoryException('Failed to delete driverexcludedzone: ${e.message}')
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

