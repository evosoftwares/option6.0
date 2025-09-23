// lib/infrastructure/repositories/supabase_driveroperationalcitie_repository.dart
import '../../domain/entities/driveroperationalcitie.dart';
import '../../domain/repositories/driveroperationalcitie_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/driver_operational_cities.dart';
import '../mappers/driveroperationalcitie_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseDriverOperationalCitieRepository implements DriverOperationalCitieRepository {
  final DriverOperationalCitiesTable _table;
  final DriverOperationalCitieMapper _mapper;
  
  SupabaseDriverOperationalCitieRepository({
    required DriverOperationalCitiesTable table,
    required DriverOperationalCitieMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<DriverOperationalCitie?>> findById(String id) async {
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
        RepositoryException('Failed to find driveroperationalcitie: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<DriverOperationalCitie>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all driveroperationalcities: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(DriverOperationalCitie driveroperationalcitie) async {
    try {
      final data = _mapper.toSupabase(driveroperationalcitie);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save driveroperationalcitie: ${e.message}')
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
        RepositoryException('Failed to delete driveroperationalcitie: ${e.message}')
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

