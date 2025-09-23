import '../database.dart';

class LocationUpdatesTable extends SupabaseTable<LocationUpdatesRow> {
  @override
  String get tableName => 'location_updates';

  @override
  LocationUpdatesRow createRow(Map<String, dynamic> data) => LocationUpdatesRow(data);
}

class LocationUpdatesRow extends SupabaseDataRow {
  LocationUpdatesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => LocationUpdatesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get sharingId => getField<String>('sharing_id');
  set sharingId(String? value) => setField<String>('sharing_id', value);

  double? get latitude => getField<double>('latitude');
  set latitude(double? value) => setField<double>('latitude', value);

  double? get longitude => getField<double>('longitude');
  set longitude(double? value) => setField<double>('longitude', value);

  DateTime? get timestamp => getField<DateTime>('timestamp');
  set timestamp(DateTime? value) => setField<DateTime>('timestamp', value);

}