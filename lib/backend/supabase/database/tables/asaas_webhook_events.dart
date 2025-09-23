import '../database.dart';

class AsaasWebhookEventsTable extends SupabaseTable<AsaasWebhookEventsRow> {
  @override
  String get tableName => 'asaas_webhook_events';

  @override
  AsaasWebhookEventsRow createRow(Map<String, dynamic> data) => AsaasWebhookEventsRow(data);
}

class AsaasWebhookEventsRow extends SupabaseDataRow {
  AsaasWebhookEventsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AsaasWebhookEventsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get asaasEventId => getField<String>('asaas_event_id');
  set asaasEventId(String? value) => setField<String>('asaas_event_id', value);

  String? get eventType => getField<String>('event_type');
  set eventType(String? value) => setField<String>('event_type', value);

  String? get paymentId => getField<String>('payment_id');
  set paymentId(String? value) => setField<String>('payment_id', value);

  dynamic? get payload => getField<dynamic>('payload');
  set payload(dynamic? value) => setField<dynamic>('payload', value);

  DateTime? get processedAt => getField<DateTime>('processed_at');
  set processedAt(DateTime? value) => setField<DateTime>('processed_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

}