// lib/domain/entities/asaaswebhookevent.dart


class AsaasWebhookEvent {
  final String id;
  final String asaasEventId;
  final String eventType;
  final String paymentId;
  final dynamic payload;
  final DateTime processedAt;
  final DateTime createdAt;

  const AsaasWebhookEvent({
    required this.id,
    required this.asaasEventId,
    required this.eventType,
    required this.paymentId,
    required this.payload,
    required this.processedAt,
    required this.createdAt,
  });

  AsaasWebhookEvent copyWith({
    String? id,
    String? asaasEventId,
    String? eventType,
    String? paymentId,
    dynamic payload,
    DateTime? processedAt,
    DateTime? createdAt,
  }) {
    return AsaasWebhookEvent(
      id: id ?? this.id,
      asaasEventId: asaasEventId ?? this.asaasEventId,
      eventType: eventType ?? this.eventType,
      paymentId: paymentId ?? this.paymentId,
      payload: payload ?? this.payload,
      processedAt: processedAt ?? this.processedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AsaasWebhookEvent &&
            other.id == this.id &&
            other.asaasEventId == this.asaasEventId &&
            other.eventType == this.eventType &&
            other.paymentId == this.paymentId &&
            other.payload == this.payload &&
            other.processedAt == this.processedAt &&
            other.createdAt == this.createdAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      asaasEventId,
      eventType,
      paymentId,
      payload,
      processedAt,
      createdAt,
    );
  }

  @override
  String toString() => 'AsaasWebhookEvent(id: $id)';
}
