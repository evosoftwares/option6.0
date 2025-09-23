// lib/domain/repositories/passengerpromocode_repository.dart
import '../entities/passengerpromocode.dart';
import '../value_objects/result.dart';


abstract class PassengerPromoCodeRepository {
  Future<Result<PassengerPromoCode?>> findById(String id);
  Future<Result<List<PassengerPromoCode>>> findAll();
  Future<Result<void>> save(PassengerPromoCode passengerpromocode);
  Future<Result<void>> delete(String id);

}
