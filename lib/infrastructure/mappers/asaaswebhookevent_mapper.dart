// lib/infrastructure/mappers/asaaswebhookevent_mapper.dart
import '../../domain/entities/asaaswebhookevent.dart';
import '../../backend/supabase/database/tables/asaas_webhook_events.dart';


class AsaasWebhookEventMapper {
  AsaasWebhookEvent toDomain(AsaasWebhookEventsRow row) {
    return AsaasWebhookEvent(
      id: row.id,
      asaasEventId: row.asaasEventId ?? '',
      eventType: row.eventType ?? '',
      paymentId: row.paymentId ?? '',
      payload: row.payload,
      processedAt: row.processedAt ?? DateTime.now(),
      createdAt: row.createdAt ?? DateTime.now(),
    );
  }
  
  Map<String, dynamic> toSupabase(AsaasWebhookEvent entity) {
    return {
      'id': entity.id,
      'asaas_event_id': entity.asaasEventId,
      'event_type': entity.eventType,
      'payment_id': entity.paymentId,
      'payload': entity.payload,
      'processed_at': entity.processedAt,
      'created_at': entity.createdAt,
    };
  }

}
