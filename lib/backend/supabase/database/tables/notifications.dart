import '../database.dart';
import '/backend/supabase/supabase.dart';

class NotificationsTable extends SupabaseTable<NotificationsRow> {
  @override
  String get tableName => 'notifications';

  @override
  NotificationsRow createRow(Map<String, dynamic> data) => NotificationsRow(data);
}

class NotificationsRow extends SupabaseDataRow {
  NotificationsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => NotificationsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get body => getField<String>('body');
  set body(String? value) => setField<String>('body', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  Map<String, dynamic> get data => getField<Map<String, dynamic>>('data') ?? {};
  set data(Map<String, dynamic> value) => setField<Map<String, dynamic>>('data', value);

  String? get priority => getField<String>('priority');
  set priority(String? value) => setField<String>('priority', value);

  bool? get isRead => getField<bool>('is_read');
  set isRead(bool? value) => setField<bool>('is_read', value);

  DateTime? get sentAt => getField<DateTime>('sent_at');
  set sentAt(DateTime? value) => setField<DateTime>('sent_at', value);

  DateTime? get readAt => getField<DateTime>('read_at');
  set readAt(DateTime? value) => setField<DateTime>('read_at', value);

}