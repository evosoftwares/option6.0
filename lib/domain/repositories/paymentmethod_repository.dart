// lib/domain/repositories/paymentmethod_repository.dart
import '../entities/paymentmethod.dart';
import '../value_objects/result.dart';


abstract class PaymentMethodRepository {
  Future<Result<PaymentMethod?>> findById(String id);
  Future<Result<List<PaymentMethod>>> findAll();
  Future<Result<void>> save(PaymentMethod paymentmethod);
  Future<Result<void>> delete(String id);

  Future<Result<PaymentMethod?>> findByUserId(String userId);
}
