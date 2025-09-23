// lib/domain/repositories/passengerwallettransaction_repository.dart
import '../entities/passengerwallettransaction.dart';
import '../value_objects/result.dart';


abstract class PassengerWalletTransactionRepository {
  Future<Result<PassengerWalletTransaction?>> findById(String id);
  Future<Result<List<PassengerWalletTransaction>>> findAll();
  Future<Result<void>> save(PassengerWalletTransaction passengerwallettransaction);
  Future<Result<void>> delete(String id);

}
