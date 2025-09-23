// lib/domain/repositories/promocodeusage_repository.dart
import '../entities/promocodeusage.dart';
import '../value_objects/result.dart';


abstract class PromoCodeUsageRepository {
  Future<Result<PromoCodeUsage?>> findById(String id);
  Future<Result<List<PromoCodeUsage>>> findAll();
  Future<Result<void>> save(PromoCodeUsage promocodeusage);
  Future<Result<void>> delete(String id);

}
