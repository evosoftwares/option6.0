// lib/domain/repositories/driverscheduleoverride_repository.dart
import '../entities/driverscheduleoverride.dart';
import '../value_objects/result.dart';


abstract class DriverScheduleOverrideRepository {
  Future<Result<DriverScheduleOverride?>> findById(String id);
  Future<Result<List<DriverScheduleOverride>>> findAll();
  Future<Result<void>> save(DriverScheduleOverride driverscheduleoverride);
  Future<Result<void>> delete(String id);

}
