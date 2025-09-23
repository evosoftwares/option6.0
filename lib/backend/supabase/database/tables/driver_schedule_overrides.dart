import '../database.dart';

class DriverScheduleOverridesTable extends SupabaseTable<DriverScheduleOverridesRow> {
  @override
  String get tableName => 'driver_schedule_overrides';

  @override
  DriverScheduleOverridesRow createRow(Map<String, dynamic> data) => DriverScheduleOverridesRow(data);
}

class DriverScheduleOverridesRow extends SupabaseDataRow {
  DriverScheduleOverridesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DriverScheduleOverridesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get driverId => getField<String>('driver_id');
  set driverId(String? value) => setField<String>('driver_id', value);

  DateTime? get overrideStart => getField<DateTime>('override_start');
  set overrideStart(DateTime? value) => setField<DateTime>('override_start', value);

  DateTime? get overrideEnd => getField<DateTime>('override_end');
  set overrideEnd(DateTime? value) => setField<DateTime>('override_end', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  String? get reason => getField<String>('reason');
  set reason(String? value) => setField<String>('reason', value);

  String? get createdBy => getField<String>('created_by');
  set createdBy(String? value) => setField<String>('created_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

}