// lib/domain/repositories/asaaswebhookevent_repository.dart
import '../entities/asaaswebhookevent.dart';
import '../value_objects/result.dart';


abstract class AsaasWebhookEventRepository {
  Future<Result<AsaasWebhookEvent?>> findById(String id);
  Future<Result<List<AsaasWebhookEvent>>> findAll();
  Future<Result<void>> save(AsaasWebhookEvent asaaswebhookevent);
  Future<Result<void>> delete(String id);

}
