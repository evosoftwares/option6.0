// lib/domain/repositories/passengerpromocodeusage_repository.dart
import '../entities/passengerpromocodeusage.dart';
import '../value_objects/result.dart';


abstract class PassengerPromoCodeUsageRepository {
  Future<Result<PassengerPromoCodeUsage?>> findById(String id);
  Future<Result<List<PassengerPromoCodeUsage>>> findAll();
  Future<Result<void>> save(PassengerPromoCodeUsage passengerpromocodeusage);
  Future<Result<void>> delete(String id);

  Future<Result<PassengerPromoCodeUsage?>> findByUserId(String userId);
}
