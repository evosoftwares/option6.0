// lib/domain/repositories/platformsetting_repository.dart
import '../entities/platformsetting.dart';
import '../value_objects/result.dart';


abstract class PlatformSettingRepository {
  Future<Result<PlatformSetting?>> findById(String id);
  Future<Result<List<PlatformSetting>>> findAll();
  Future<Result<void>> save(PlatformSetting platformsetting);
  Future<Result<void>> delete(String id);

}
