import '../database.dart';

class DriverStatusTable extends SupabaseTable<DriverStatusRow> {
  @override
  String get tableName => 'driver_status';

  @override
  DriverStatusRow createRow(Map<String, dynamic> data) => DriverStatusRow(data);
}

class DriverStatusRow extends SupabaseDataRow {
  DriverStatusRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DriverStatusTable();

  String get driverId => getField<String>('driver_id')!;
  set driverId(String value) => setField<String>('driver_id', value);

  bool? get onlineIntent => getField<bool>('online_intent');
  set onlineIntent(bool? value) => setField<bool>('online_intent', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

}