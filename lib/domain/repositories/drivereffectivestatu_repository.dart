// lib/domain/repositories/drivereffectivestatu_repository.dart
import '../entities/drivereffectivestatu.dart';
import '../value_objects/result.dart';


abstract class DriverEffectiveStatuRepository {
  Future<Result<DriverEffectiveStatu?>> findById(String id);
  Future<Result<List<DriverEffectiveStatu>>> findAll();
  Future<Result<void>> save(DriverEffectiveStatu drivereffectivestatu);
  Future<Result<void>> delete(String id);

}
