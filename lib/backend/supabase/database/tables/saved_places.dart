import '../database.dart';

class SavedPlacesTable extends SupabaseTable<SavedPlacesRow> {
  @override
  String get tableName => 'saved_places';

  @override
  SavedPlacesRow createRow(Map<String, dynamic> data) => SavedPlacesRow(data);
}

class SavedPlacesRow extends SupabaseDataRow {
  SavedPlacesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SavedPlacesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  dynamic? get label => getField<dynamic>('label');
  set label(dynamic? value) => setField<dynamic>('label', value);

  String? get address => getField<String>('address');
  set address(String? value) => setField<String>('address', value);

  dynamic? get latitude => getField<dynamic>('latitude');
  set latitude(dynamic? value) => setField<dynamic>('latitude', value);

  dynamic? get longitude => getField<dynamic>('longitude');
  set longitude(dynamic? value) => setField<dynamic>('longitude', value);

  dynamic? get category => getField<dynamic>('category');
  set category(dynamic? value) => setField<dynamic>('category', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

}