// lib/domain/repositories/driveroperationalcitie_repository.dart
import '../entities/driveroperationalcitie.dart';
import '../value_objects/result.dart';


abstract class DriverOperationalCitieRepository {
  Future<Result<DriverOperationalCitie?>> findById(String id);
  Future<Result<List<DriverOperationalCitie>>> findAll();
  Future<Result<void>> save(DriverOperationalCitie driveroperationalcitie);
  Future<Result<void>> delete(String id);

}
