// lib/infrastructure/repositories/supabase_driverscheduleoverride_repository.dart
import '../../domain/entities/driverscheduleoverride.dart';
import '../../domain/repositories/driverscheduleoverride_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/driver_schedule_overrides.dart';
import '../mappers/driverscheduleoverride_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseDriverScheduleOverrideRepository implements DriverScheduleOverrideRepository {
  final DriverScheduleOverridesTable _table;
  final DriverScheduleOverrideMapper _mapper;
  
  SupabaseDriverScheduleOverrideRepository({
    required DriverScheduleOverridesTable table,
    required DriverScheduleOverrideMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<DriverScheduleOverride?>> findById(String id) async {
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
        RepositoryException('Failed to find driverscheduleoverride: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<DriverScheduleOverride>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all driverscheduleoverrides: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(DriverScheduleOverride driverscheduleoverride) async {
    try {
      final data = _mapper.toSupabase(driverscheduleoverride);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save driverscheduleoverride: ${e.message}')
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
        RepositoryException('Failed to delete driverscheduleoverride: ${e.message}')
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

