// lib/domain/repositories/driverdocument_repository.dart
import '../entities/driverdocument.dart';
import '../value_objects/result.dart';


abstract class DriverDocumentRepository {
  Future<Result<DriverDocument?>> findById(String id);
  Future<Result<List<DriverDocument>>> findAll();
  Future<Result<void>> save(DriverDocument driverdocument);
  Future<Result<void>> delete(String id);

}
