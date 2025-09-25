import '../database.dart';
import '/backend/supabase/supabase.dart';

class DriverPreferenceFeesTable
    extends SupabaseTable<DriverPreferenceFeesRow> {
  @override
  String get tableName => 'driver_preference_fees';

  @override
  DriverPreferenceFeesRow createRow(Map<String, dynamic> data) =>
      DriverPreferenceFeesRow(data);
}

class DriverPreferenceFeesRow extends SupabaseDataRow {
  DriverPreferenceFeesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DriverPreferenceFeesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get driverId => getField<String>('driver_id')!;
  set driverId(String value) => setField<String>('driver_id', value);

  String get preferenceKey => getField<String>('preference_key')!;
  set preferenceKey(String value) => setField<String>('preference_key', value);

  bool? get enabled => getField<bool>('enabled');
  set enabled(bool? value) => setField<bool>('enabled', value);

  dynamic get fee => getField<dynamic>('fee');
  set fee(dynamic value) => setField<dynamic>('fee', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}


