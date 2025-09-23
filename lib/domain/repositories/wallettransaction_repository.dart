// lib/domain/repositories/wallettransaction_repository.dart
import '../entities/wallettransaction.dart';
import '../value_objects/result.dart';


abstract class WalletTransactionRepository {
  Future<Result<WalletTransaction?>> findById(String id);
  Future<Result<List<WalletTransaction>>> findAll();
  Future<Result<void>> save(WalletTransaction wallettransaction);
  Future<Result<void>> delete(String id);

}
