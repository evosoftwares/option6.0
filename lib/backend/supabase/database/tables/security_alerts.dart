import '../database.dart';

class SecurityAlertsTable extends SupabaseTable<SecurityAlertsRow> {
  @override
  String get tableName => 'security_alerts';

  @override
  SecurityAlertsRow createRow(Map<String, dynamic> data) => SecurityAlertsRow(data);
}

class SecurityAlertsRow extends SupabaseDataRow {
  SecurityAlertsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SecurityAlertsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get alertType => getField<String>('alert_type');
  set alertType(String? value) => setField<String>('alert_type', value);

  String? get severity => getField<String>('severity');
  set severity(String? value) => setField<String>('severity', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  dynamic? get metadata => getField<dynamic>('metadata');
  set metadata(dynamic? value) => setField<dynamic>('metadata', value);

  bool? get resolved => getField<bool>('resolved');
  set resolved(bool? value) => setField<bool>('resolved', value);

  DateTime? get resolvedAt => getField<DateTime>('resolved_at');
  set resolvedAt(DateTime? value) => setField<DateTime>('resolved_at', value);

  String? get resolvedBy => getField<String>('resolved_by');
  set resolvedBy(String? value) => setField<String>('resolved_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

}