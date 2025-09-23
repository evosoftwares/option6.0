// lib/infrastructure/repositories/supabase_passenger_repository.dart
import '../../domain/entities/passenger.dart';
import '../../domain/entities/trip.dart';
import '../../domain/repositories/passenger_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/passengers.dart';
import '../../backend/supabase/database/tables/trips.dart';
import '../mappers/passenger_mapper.dart';
import '../mappers/trip_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabasePassengerRepository implements PassengerRepository {
  final PassengersTable _table;
  final PassengerMapper _mapper;
  final TripsTable _tripsTable;
  final TripMapper _tripMapper;
  
  SupabasePassengerRepository({
    required PassengersTable table,
    required PassengerMapper mapper,
    required TripsTable tripsTable,
    required TripMapper tripMapper,
  }) : _table = table,
        _mapper = mapper,
        _tripsTable = tripsTable,
        _tripMapper = tripMapper;

  @override
  Future<Result<Passenger?>> findById(String id) async {
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
        RepositoryException('Failed to find passenger: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<List<Passenger>>> findAll() async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find all passengers: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<void>> save(Passenger passenger) async {
    try {
      final data = _mapper.toSupabase(passenger);
      await _table.insert(data);
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to save passenger: ${e.message}')
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
        RepositoryException('Failed to delete passenger: ${e.message}')
      );
    } catch (e) {
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }
  }

  @override
  Future<Result<Passenger?>> findByUserId(String userId) async {
    try {
      final rows = await _table.queryRows(
        queryFn: (q) => q.eq('user_id', userId).limit(1),
      );
      if (rows.isEmpty) {
        return Result.success(null);
      }
      final entity = _mapper.toDomain(rows.first);
      return Result.success(entity);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find passenger by user ID: ${e.message}')
      );
    }
  }

  @override
  Future<Result<List<Trip>>> getTripHistory(String passengerId) async {
    try {
      final rows = await _tripsTable.queryRows(
        queryFn: (q) => q.eq('passenger_id', passengerId),
      );
      final entities = rows.map(_tripMapper.toDomain).toList();
      return Result.success(entities);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to get trip history: ${e.message}')
      );
    }
  }

  @override
  Future<Result<void>> updateRating(String passengerId, double rating) async {
    try {
      await _table.update(
        data: {'average_rating': rating},
        matchingRows: (rows) => rows.eq('id', passengerId),
      );
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to update rating: ${e.message}')
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

