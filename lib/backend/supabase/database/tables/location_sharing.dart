import '../database.dart';

class LocationSharingTable extends SupabaseTable<LocationSharingRow> {
  @override
  String get tableName => 'location_sharing';

  @override
  LocationSharingRow createRow(Map<String, dynamic> data) => LocationSharingRow(data);
}

class LocationSharingRow extends SupabaseDataRow {
  LocationSharingRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => LocationSharingTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  DateTime? get expiresAt => getField<DateTime>('expires_at');
  set expiresAt(DateTime? value) => setField<DateTime>('expires_at', value);

  List<String> get sharedWithUsers => getListField<String>('shared_with_users');
  set sharedWithUsers(List<String>? value) => setListField<String>('shared_with_users', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get endedAt => getField<DateTime>('ended_at');
  set endedAt(DateTime? value) => setField<DateTime>('ended_at', value);

}