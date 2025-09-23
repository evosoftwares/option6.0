// lib/domain/repositories/promocode_repository.dart
import '../entities/promocode.dart';
import '../value_objects/result.dart';


abstract class PromoCodeRepository {
  Future<Result<PromoCode?>> findById(String id);
  Future<Result<List<PromoCode>>> findAll();
  Future<Result<void>> save(PromoCode promocode);
  Future<Result<void>> delete(String id);

}
