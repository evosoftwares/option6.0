// lib/infrastructure/repositories/supabase_trip_repository.dart
import '../../domain/entities/trip.dart';
import '../../domain/repositories/trip_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/trips.dart';
import '../mappers/trip_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseTripRepository implements TripRepository {
  final TripsTable _table;
  final TripMapper _mapper;
  
  SupabaseTripRepository({
    required TripsTable table,
    required TripMapper mapper,
  })  : _table = table,
        _mapper = mapper;

  @override
  Future<Result<Trip?>> findById(String id) async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q.eq('id', id).limit(1),
      );
      if (rows.isEmpty) {
        return Result.success(null);
      }
      final entity = _mapper.toDomain(rows.first);
      return Result.success(entity);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find trip by id: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<Trip>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all trips: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(Trip trip) async {
    try {
      final data = _mapper.toSupabase(trip);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save trip: ${e.message}')
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
        RepositoryException('Failed to delete trip: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<Trip>>> findByPassengerId(String passengerId) async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q.eq('passenger_id', passengerId),
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find trips by passenger: ${e.message}')
      );
    }
  }

  @override
  Future<Result<List<Trip>>> findByDriverId(String driverId) async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q.eq('driver_id', driverId),
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find trips by driver: ${e.message}')
      );
    }
  }

  @override
  Future<Result<List<Trip>>> findByStatus(String status) async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q.eq('status', status),
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find trips by status: ${e.message}')
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

