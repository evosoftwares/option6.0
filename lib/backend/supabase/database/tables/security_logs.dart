import '../database.dart';

class SecurityLogsTable extends SupabaseTable<SecurityLogsRow> {
  @override
  String get tableName => 'security_logs';

  @override
  SecurityLogsRow createRow(Map<String, dynamic> data) => SecurityLogsRow(data);
}

class SecurityLogsRow extends SupabaseDataRow {
  SecurityLogsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SecurityLogsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get eventType => getField<String>('event_type');
  set eventType(String? value) => setField<String>('event_type', value);

  String? get severity => getField<String>('severity');
  set severity(String? value) => setField<String>('severity', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get ipAddress => getField<String>('ip_address');
  set ipAddress(String? value) => setField<String>('ip_address', value);

  String? get userAgent => getField<String>('user_agent');
  set userAgent(String? value) => setField<String>('user_agent', value);

  dynamic get deviceInfo => getField<dynamic>('device_info');
  set deviceInfo(dynamic value) => setField<dynamic>('device_info', value);

  String? get platform => getField<String>('platform');
  set platform(String? value) => setField<String>('platform', value);

  String? get appVersion => getField<String>('app_version');
  set appVersion(String? value) => setField<String>('app_version', value);

  String? get sessionId => getField<String>('session_id');
  set sessionId(String? value) => setField<String>('session_id', value);

  dynamic get metadata => getField<dynamic>('metadata');
  set metadata(dynamic value) => setField<dynamic>('metadata', value);

  DateTime? get timestamp => getField<DateTime>('timestamp');
  set timestamp(DateTime? value) => setField<DateTime>('timestamp', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

}