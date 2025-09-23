import '../database.dart';

class TripChatsTable extends SupabaseTable<TripChatsRow> {
  @override
  String get tableName => 'trip_chats';

  @override
  TripChatsRow createRow(Map<String, dynamic> data) => TripChatsRow(data);
}

class TripChatsRow extends SupabaseDataRow {
  TripChatsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TripChatsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get tripId => getField<String>('trip_id');
  set tripId(String? value) => setField<String>('trip_id', value);

  String? get senderId => getField<String>('sender_id');
  set senderId(String? value) => setField<String>('sender_id', value);

  String? get message => getField<String>('message');
  set message(String? value) => setField<String>('message', value);

  bool? get isRead => getField<bool>('is_read');
  set isRead(bool? value) => setField<bool>('is_read', value);

  DateTime? get readAt => getField<DateTime>('read_at');
  set readAt(DateTime? value) => setField<DateTime>('read_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

}