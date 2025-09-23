import '../database.dart';

class CorruptedUsersBackupTable extends SupabaseTable<CorruptedUsersBackupRow> {
  @override
  String get tableName => 'corrupted_users_backup';

  @override
  CorruptedUsersBackupRow createRow(Map<String, dynamic> data) => CorruptedUsersBackupRow(data);
}

class CorruptedUsersBackupRow extends SupabaseDataRow {
  CorruptedUsersBackupRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CorruptedUsersBackupTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get originalUserId => getField<String>('original_user_id');
  set originalUserId(String? value) => setField<String>('original_user_id', value);

  String? get originalFullName => getField<String>('original_full_name');
  set originalFullName(String? value) => setField<String>('original_full_name', value);

  String? get originalPhone => getField<String>('original_phone');
  set originalPhone(String? value) => setField<String>('original_phone', value);

  String? get originalEmail => getField<String>('original_email');
  set originalEmail(String? value) => setField<String>('original_email', value);

  DateTime? get correctionTimestamp => getField<DateTime>('correction_timestamp');
  set correctionTimestamp(DateTime? value) => setField<DateTime>('correction_timestamp', value);

  String? get correctionReason => getField<String>('correction_reason');
  set correctionReason(String? value) => setField<String>('correction_reason', value);

  bool? get restored => getField<bool>('restored');
  set restored(bool? value) => setField<bool>('restored', value);

  DateTime? get restoredAt => getField<DateTime>('restored_at');
  set restoredAt(DateTime? value) => setField<DateTime>('restored_at', value);

}