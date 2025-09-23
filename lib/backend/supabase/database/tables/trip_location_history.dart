import '../database.dart';

class TripLocationHistoryTable extends SupabaseTable<TripLocationHistoryRow> {
  @override
  String get tableName => 'trip_location_history';

  @override
  TripLocationHistoryRow createRow(Map<String, dynamic> data) => TripLocationHistoryRow(data);
}

class TripLocationHistoryRow extends SupabaseDataRow {
  TripLocationHistoryRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TripLocationHistoryTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get tripId => getField<String>('trip_id');
  set tripId(String? value) => setField<String>('trip_id', value);

  dynamic? get latitude => getField<dynamic>('latitude');
  set latitude(dynamic? value) => setField<dynamic>('latitude', value);

  dynamic? get longitude => getField<dynamic>('longitude');
  set longitude(dynamic? value) => setField<dynamic>('longitude', value);

  dynamic? get speedKmh => getField<dynamic>('speed_kmh');
  set speedKmh(dynamic? value) => setField<dynamic>('speed_kmh', value);

  dynamic? get heading => getField<dynamic>('heading');
  set heading(dynamic? value) => setField<dynamic>('heading', value);

  dynamic? get accuracyMeters => getField<dynamic>('accuracy_meters');
  set accuracyMeters(dynamic? value) => setField<dynamic>('accuracy_meters', value);

  DateTime? get recordedAt => getField<DateTime>('recorded_at');
  set recordedAt(DateTime? value) => setField<DateTime>('recorded_at', value);

}