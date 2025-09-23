// lib/infrastructure/repositories/supabase_driver_repository.dart
import '../../domain/entities/driver.dart';
import '../../domain/repositories/driver_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/drivers.dart';
import '../mappers/driver_mapper.dart';
import '../../domain/value_objects/location.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseDriverRepository implements DriverRepository {
  final DriversTable _table;
  final DriverMapper _mapper;
  
  SupabaseDriverRepository({
    required DriversTable table,
    required DriverMapper mapper,
  }) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<Driver?>> findById(String id) async {
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
        RepositoryException('Failed to find driver: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<Driver>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all drivers: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(Driver driver) async {
    try {
      final data = _mapper.toSupabase(driver);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save driver: ${e.message}')
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
        RepositoryException('Failed to delete driver: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<Driver?>> findByUserId(String userId) async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q.eq('user_id', userId),
      );
      
      if (rows.isEmpty) {
        return Result.success(null);
      }
      
      final entity = _mapper.toDomain(rows.first);
      return Result.success(entity);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find driver by user ID: ${e.message}')
      );
    }
  }

  @override
  Future<Result<List<Driver>>> findAvailableInRadius(
    Location center, 
    Distance radius
  ) async {
    try {
      // Implementar query geográfica
      final rows = await _table.queryRows(
        queryFn: (q) => q
            .eq('is_online', true)
            .eq('approval_status', 'approved')
            .gte('updated_at', 
                 DateTime.now().subtract(Duration(minutes: 5)).toIso8601String()),
      );
      
      // Filtrar por distância (implementação simplificada)
      final drivers = rows.map(_mapper.toDomain).toList();
      final filtered = drivers.where((driver) {
        if (driver.currentLocation == null) return false;
        return driver.currentLocation!.isWithinRadius(center, radius);
      }).toList();
      
      return Result.success(filtered);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find available drivers: ${e.message}')
      );
    }
  }

  Future<Result<void>> updateOnlineStatus(String driverId, bool isOnline) async {
    try {
      await _table.update(
        data: {'is_online': isOnline, 'updated_at': DateTime.now().toIso8601String()},
        matchingRows: (rows) => rows.eq('id', driverId),
      );
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to update online status: ${e.message}')
      );
    }
  }

  Future<Result<void>> updateLocation(String driverId, Location location) async {
    try {
      await _table.update(
        data: {
          'current_latitude': location.latitude,
          'current_longitude': location.longitude,
          'updated_at': DateTime.now().toIso8601String(),
        },
        matchingRows: (rows) => rows.eq('id', driverId),
      );
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to update location: ${e.message}')
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
