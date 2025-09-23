// lib/infrastructure/repositories/supabase_driverexcludedzonesstat_repository.dart
import '../../domain/entities/driverexcludedzonesstat.dart';
import '../../domain/repositories/driverexcludedzonesstat_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/driver_excluded_zones.dart';
import '../mappers/driverexcludedzonesstat_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseDriverExcludedZonesStatRepository implements DriverExcludedZonesStatRepository {
  final DriverExcludedZonesTable _table;
  final DriverExcludedZonesStatMapper _mapper;
  
  SupabaseDriverExcludedZonesStatRepository({
    required DriverExcludedZonesTable table,
    required DriverExcludedZonesStatMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<DriverExcludedZonesStat?>> findById(String id) async {
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
        RepositoryException('Failed to find driverexcludedzonesstat: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<DriverExcludedZonesStat>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final List<DriverExcludedZonesStat> entities =
          rows.map<DriverExcludedZonesStat>(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all driverexcludedzonesstats: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(DriverExcludedZonesStat driverexcludedzonesstat) async {
    try {
      final data = _mapper.toSupabase(driverexcludedzonesstat);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save driverexcludedzonesstat: ${e.message}')
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
        RepositoryException('Failed to delete driverexcludedzonesstat: ${e.message}')
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

