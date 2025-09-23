import '../database.dart';

class BackupConflict409RemovalTable extends SupabaseTable<BackupConflict409RemovalRow> {
  @override
  String get tableName => 'backup_conflict_409_removal';

  @override
  BackupConflict409RemovalRow createRow(Map<String, dynamic> data) => BackupConflict409RemovalRow(data);
}

class BackupConflict409RemovalRow extends SupabaseDataRow {
  BackupConflict409RemovalRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BackupConflict409RemovalTable();

  String? get sourceTable => getField<String>('source_table');
  set sourceTable(String? value) => setField<String>('source_table', value);

  DateTime? get backupTimestamp => getField<DateTime>('backup_timestamp');
  set backupTimestamp(DateTime? value) => setField<DateTime>('backup_timestamp', value);

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get fullName => getField<String>('full_name');
  set fullName(String? value) => setField<String>('full_name', value);

  String? get phone => getField<String>('phone');
  set phone(String? value) => setField<String>('phone', value);

  String? get photoUrl => getField<String>('photo_url');
  set photoUrl(String? value) => setField<String>('photo_url', value);

  String? get userType => getField<String>('user_type');
  set userType(String? value) => setField<String>('user_type', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

}