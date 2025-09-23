// lib/domain/repositories/trip_repository.dart
import '../entities/trip.dart';
import '../value_objects/result.dart';

abstract class TripRepository {
  Future<Result<Trip?>> findById(String id);
  Future<Result<List<Trip>>> findAll();
  Future<Result<void>> save(Trip trip);
  Future<Result<void>> delete(String id);

  Future<Result<List<Trip>>> findByPassengerId(String passengerId);
  Future<Result<List<Trip>>> findByDriverId(String driverId);
  Future<Result<List<Trip>>> findByStatus(String status);
}
