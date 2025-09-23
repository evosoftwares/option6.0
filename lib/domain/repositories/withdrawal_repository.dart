// lib/domain/repositories/withdrawal_repository.dart
import '../entities/withdrawal.dart';
import '../value_objects/result.dart';


abstract class WithdrawalRepository {
  Future<Result<Withdrawal?>> findById(String id);
  Future<Result<List<Withdrawal>>> findAll();
  Future<Result<void>> save(Withdrawal withdrawal);
  Future<Result<void>> delete(String id);

}
