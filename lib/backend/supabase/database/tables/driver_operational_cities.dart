import '../database.dart';

class DriverOperationalCitiesTable extends SupabaseTable<DriverOperationalCitiesRow> {
  @override
  String get tableName => 'driver_operational_cities';

  @override
  DriverOperationalCitiesRow createRow(Map<String, dynamic> data) => DriverOperationalCitiesRow(data);
}

class DriverOperationalCitiesRow extends SupabaseDataRow {
  DriverOperationalCitiesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DriverOperationalCitiesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get driverId => getField<String>('driver_id');
  set driverId(String? value) => setField<String>('driver_id', value);

  String? get cityId => getField<String>('city_id');
  set cityId(String? value) => setField<String>('city_id', value);

  bool? get isPrimary => getField<bool>('is_primary');
  set isPrimary(bool? value) => setField<bool>('is_primary', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

}