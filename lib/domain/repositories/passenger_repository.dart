// lib/domain/repositories/passenger_repository.dart
import '../entities/passenger.dart';
import '../entities/trip.dart';
import '../value_objects/result.dart';


abstract class PassengerRepository {
  Future<Result<Passenger?>> findById(String id);
  Future<Result<List<Passenger>>> findAll();
  Future<Result<void>> save(Passenger passenger);
  Future<Result<void>> delete(String id);

  Future<Result<Passenger?>> findByUserId(String userId);
  Future<Result<List<Trip>>> getTripHistory(String passengerId);
  Future<Result<void>> updateRating(String passengerId, double rating);
}
