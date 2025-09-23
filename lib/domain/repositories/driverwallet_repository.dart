// lib/domain/repositories/driverwallet_repository.dart
import '../entities/driverwallet.dart';
import '../value_objects/result.dart';


abstract class DriverWalletRepository {
  Future<Result<DriverWallet?>> findById(String id);
  Future<Result<List<DriverWallet>>> findAll();
  Future<Result<void>> save(DriverWallet driverwallet);
  Future<Result<void>> delete(String id);

}
