// lib/domain/repositories/passengerwallet_repository.dart
import '../entities/passengerwallet.dart';
import '../value_objects/result.dart';


abstract class PassengerWalletRepository {
  Future<Result<PassengerWallet?>> findById(String id);
  Future<Result<List<PassengerWallet>>> findAll();
  Future<Result<void>> save(PassengerWallet passengerwallet);
  Future<Result<void>> delete(String id);

}
