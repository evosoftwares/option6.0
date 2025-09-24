import '../database.dart';

class OperationalCitiesTable extends SupabaseTable<OperationalCitiesRow> {
  @override
  String get tableName => 'operational_cities';

  @override
  OperationalCitiesRow createRow(Map<String, dynamic> data) => OperationalCitiesRow(data);
}

class OperationalCitiesRow extends SupabaseDataRow {
  OperationalCitiesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OperationalCitiesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get state => getField<String>('state');
  set state(String? value) => setField<String>('state', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  dynamic get minFare => getField<dynamic>('min_fare');
  set minFare(dynamic value) => setField<dynamic>('min_fare', value);

  DateTime? get launchDate => getField<DateTime>('launch_date');
  set launchDate(DateTime? value) => setField<DateTime>('launch_date', value);

  dynamic get polygonCoordinates => getField<dynamic>('polygon_coordinates');
  set polygonCoordinates(dynamic value) => setField<dynamic>('polygon_coordinates', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

}