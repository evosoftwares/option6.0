// lib/domain/repositories/operationalcitie_repository.dart
import '../entities/operationalcitie.dart';
import '../value_objects/result.dart';


abstract class OperationalCitieRepository {
  Future<Result<OperationalCitie?>> findById(String id);
  Future<Result<List<OperationalCitie>>> findAll();
  Future<Result<void>> save(OperationalCitie operationalcitie);
  Future<Result<void>> delete(String id);

}
