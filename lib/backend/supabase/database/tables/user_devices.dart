import '../database.dart';

class UserDevicesTable extends SupabaseTable<UserDevicesRow> {
  @override
  String get tableName => 'user_devices';

  @override
  UserDevicesRow createRow(Map<String, dynamic> data) => UserDevicesRow(data);
}

class UserDevicesRow extends SupabaseDataRow {
  UserDevicesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserDevicesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get deviceToken => getField<String>('device_token');
  set deviceToken(String? value) => setField<String>('device_token', value);

  String? get platform => getField<String>('platform');
  set platform(String? value) => setField<String>('platform', value);

  String? get deviceModel => getField<String>('device_model');
  set deviceModel(String? value) => setField<String>('device_model', value);

  String? get appVersion => getField<String>('app_version');
  set appVersion(String? value) => setField<String>('app_version', value);

  String? get osVersion => getField<String>('os_version');
  set osVersion(String? value) => setField<String>('os_version', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get lastUsedAt => getField<DateTime>('last_used_at');
  set lastUsedAt(DateTime? value) => setField<DateTime>('last_used_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

}