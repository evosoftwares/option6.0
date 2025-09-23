import '../database.dart';

class DriverExcludedZonesTable extends SupabaseTable<DriverExcludedZonesRow> {
  @override
  String get tableName => 'driver_excluded_zones';

  @override
  DriverExcludedZonesRow createRow(Map<String, dynamic> data) => DriverExcludedZonesRow(data);
}

class DriverExcludedZonesRow extends SupabaseDataRow {
  DriverExcludedZonesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DriverExcludedZonesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get driverId => getField<String>('driver_id');
  set driverId(String? value) => setField<String>('driver_id', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get localName => getField<String>('local_name');
  set localName(String? value) => setField<String>('local_name', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

}