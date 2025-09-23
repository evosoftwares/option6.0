// lib/infrastructure/repositories/supabase_driveroperationzone_repository.dart
import '../../domain/entities/driveroperationzone.dart';
import '../../domain/repositories/driveroperationzone_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/driver_operation_zones.dart';
import '../mappers/driveroperationzone_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseDriverOperationZoneRepository implements DriverOperationZoneRepository {
  final DriverOperationZonesTable _table;
  final DriverOperationZoneMapper _mapper;
  
  SupabaseDriverOperationZoneRepository({
    required DriverOperationZonesTable table,
    required DriverOperationZoneMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<DriverOperationZone?>> findById(String id) async {
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
        RepositoryException('Failed to find driveroperationzone: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<DriverOperationZone>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all driveroperationzones: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(DriverOperationZone driveroperationzone) async {
    try {
      final data = _mapper.toSupabase(driveroperationzone);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save driveroperationzone: ${e.message}')
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
        RepositoryException('Failed to delete driveroperationzone: ${e.message}')
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

