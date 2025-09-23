import '../database.dart';

class TripStopsTable extends SupabaseTable<TripStopsRow> {
  @override
  String get tableName => 'trip_stops';

  @override
  TripStopsRow createRow(Map<String, dynamic> data) => TripStopsRow(data);
}

class TripStopsRow extends SupabaseDataRow {
  TripStopsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TripStopsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get tripId => getField<String>('trip_id');
  set tripId(String? value) => setField<String>('trip_id', value);

  int? get stopOrder => getField<int>('stop_order');
  set stopOrder(int? value) => setField<int>('stop_order', value);

  String? get address => getField<String>('address');
  set address(String? value) => setField<String>('address', value);

  dynamic? get latitude => getField<dynamic>('latitude');
  set latitude(dynamic? value) => setField<dynamic>('latitude', value);

  dynamic? get longitude => getField<dynamic>('longitude');
  set longitude(dynamic? value) => setField<dynamic>('longitude', value);

  DateTime? get arrivedAt => getField<DateTime>('arrived_at');
  set arrivedAt(DateTime? value) => setField<DateTime>('arrived_at', value);

  DateTime? get departedAt => getField<DateTime>('departed_at');
  set departedAt(DateTime? value) => setField<DateTime>('departed_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

}