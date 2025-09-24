import '../database.dart';

class ActivityLogsTable extends SupabaseTable<ActivityLogsRow> {
  @override
  String get tableName => 'activity_logs';

  @override
  ActivityLogsRow createRow(Map<String, dynamic> data) => ActivityLogsRow(data);
}

class ActivityLogsRow extends SupabaseDataRow {
  ActivityLogsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ActivityLogsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get action => getField<String>('action');
  set action(String? value) => setField<String>('action', value);

  String? get entityType => getField<String>('entity_type');
  set entityType(String? value) => setField<String>('entity_type', value);

  String? get entityId => getField<String>('entity_id');
  set entityId(String? value) => setField<String>('entity_id', value);

  dynamic get oldValues => getField<dynamic>('old_values');
  set oldValues(dynamic value) => setField<dynamic>('old_values', value);

  dynamic get newValues => getField<dynamic>('new_values');
  set newValues(dynamic value) => setField<dynamic>('new_values', value);

  dynamic get metadata => getField<dynamic>('metadata');
  set metadata(dynamic value) => setField<dynamic>('metadata', value);

  dynamic get ipAddress => getField<dynamic>('ip_address');
  set ipAddress(dynamic value) => setField<dynamic>('ip_address', value);

  String? get userAgent => getField<String>('user_agent');
  set userAgent(String? value) => setField<String>('user_agent', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

}