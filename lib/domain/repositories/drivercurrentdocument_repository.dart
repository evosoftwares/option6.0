// lib/domain/repositories/drivercurrentdocument_repository.dart
import '../entities/drivercurrentdocument.dart';
import '../value_objects/result.dart';


abstract class DriverCurrentDocumentRepository {
  Future<Result<DriverCurrentDocument?>> findById(String id);
  Future<Result<List<DriverCurrentDocument>>> findAll();
  Future<Result<void>> save(DriverCurrentDocument drivercurrentdocument);
  Future<Result<void>> delete(String id);

}
