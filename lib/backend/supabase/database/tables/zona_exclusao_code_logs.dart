import '../database.dart';

class ZonaExclusaoCodeLogsTable extends SupabaseTable<ZonaExclusaoCodeLogsRow> {
  @override
  String get tableName => 'zona_exclusao_code_logs';

  @override
  ZonaExclusaoCodeLogsRow createRow(Map<String, dynamic> data) => ZonaExclusaoCodeLogsRow(data);
}

class ZonaExclusaoCodeLogsRow extends SupabaseDataRow {
  ZonaExclusaoCodeLogsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ZonaExclusaoCodeLogsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get driverId => getField<String>('driver_id')!;
  set driverId(String value) => setField<String>('driver_id', value);

  String get action => getField<String>('action')!;
  set action(String value) => setField<String>('action', value);

  Map<String, dynamic> get data => getField<Map<String, dynamic>>('data') ?? {};
  set data(Map<String, dynamic> value) => setField<Map<String, dynamic>>('data', value);

  DateTime? get timestamp => getField<DateTime>('timestamp');
  set timestamp(DateTime? value) => setField<DateTime>('timestamp', value);

}