// lib/domain/repositories/activitylog_repository.dart
import '../entities/activitylog.dart';
import '../value_objects/result.dart';


abstract class ActivityLogRepository {
  Future<Result<ActivityLog?>> findById(String id);
  Future<Result<List<ActivityLog>>> findAll();
  Future<Result<void>> save(ActivityLog activitylog);
  Future<Result<void>> delete(String id);

  Future<Result<ActivityLog?>> findByUserId(String userId);
}
