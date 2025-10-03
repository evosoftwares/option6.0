import '../database.dart';
import '/backend/supabase/supabase.dart';

class AppUsersTable extends SupabaseTable<AppUsersRow> {
  @override
  String get tableName => 'app_users';

  @override
  AppUsersRow createRow(Map<String, dynamic> data) => AppUsersRow(data);
}

class AppUsersRow extends SupabaseDataRow {
  AppUsersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AppUsersTable();

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

  DateTime? get suspensionEndsAt => getField<DateTime>('suspension_ends_at');
  set suspensionEndsAt(DateTime? value) =>
      setField<DateTime>('suspension_ends_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get fcmToken => getField<String>('fcm_token');
  set fcmToken(String? value) => setField<String>('fcm_token', value);

  String? get deviceId => getField<String>('device_id');
  set deviceId(String? value) => setField<String>('device_id', value);

  String? get devicePlatform => getField<String>('device_platform');
  set devicePlatform(String? value) =>
      setField<String>('device_platform', value);

  DateTime? get lastActiveAt => getField<DateTime>('last_active_at');
  set lastActiveAt(DateTime? value) =>
      setField<DateTime>('last_active_at', value);

  bool? get profileComplete => getField<bool>('profile_complete');
  set profileComplete(bool? value) => setField<bool>('profile_complete', value);

  String? get onesignalPlayerId => getField<String>('onesignal_player_id');
  set onesignalPlayerId(String? value) =>
      setField<String>('onesignal_player_id', value);

  String? get currentUserUidFirebase =>
      getField<String>('currentUser_UID_Firebase');
  set currentUserUidFirebase(String? value) =>
      setField<String>('currentUser_UID_Firebase', value);
}
