import '../database.dart';

class TripStatusHistoryTable extends SupabaseTable<TripStatusHistoryRow> {
  @override
  String get tableName => 'trip_status_history';

  @override
  TripStatusHistoryRow createRow(Map<String, dynamic> data) => TripStatusHistoryRow(data);
}

class TripStatusHistoryRow extends SupabaseDataRow {
  TripStatusHistoryRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TripStatusHistoryTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get tripId => getField<String>('trip_id');
  set tripId(String? value) => setField<String>('trip_id', value);

  String? get oldStatus => getField<String>('old_status');
  set oldStatus(String? value) => setField<String>('old_status', value);

  String? get newStatus => getField<String>('new_status');
  set newStatus(String? value) => setField<String>('new_status', value);

  String? get changedBy => getField<String>('changed_by');
  set changedBy(String? value) => setField<String>('changed_by', value);

  String? get reason => getField<String>('reason');
  set reason(String? value) => setField<String>('reason', value);

  dynamic get metadata => getField<dynamic>('metadata');
  set metadata(dynamic value) => setField<dynamic>('metadata', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

}