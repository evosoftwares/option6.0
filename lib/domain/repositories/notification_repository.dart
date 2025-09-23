// lib/domain/repositories/notification_repository.dart
import '../entities/notification.dart';
import '../value_objects/result.dart';


abstract class NotificationRepository {
  Future<Result<Notification?>> findById(String id);
  Future<Result<List<Notification>>> findAll();
  Future<Result<void>> save(Notification notification);
  Future<Result<void>> delete(String id);

  Future<Result<Notification?>> findByUserId(String userId);
}
