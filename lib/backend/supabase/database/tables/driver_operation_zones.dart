import '../database.dart';

class DriverOperationZonesTable extends SupabaseTable<DriverOperationZonesRow> {
  @override
  String get tableName => 'driver_operation_zones';

  @override
  DriverOperationZonesRow createRow(Map<String, dynamic> data) => DriverOperationZonesRow(data);
}

class DriverOperationZonesRow extends SupabaseDataRow {
  DriverOperationZonesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DriverOperationZonesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get driverId => getField<String>('driver_id');
  set driverId(String? value) => setField<String>('driver_id', value);

  String? get zoneName => getField<String>('zone_name');
  set zoneName(String? value) => setField<String>('zone_name', value);

  dynamic get polygonCoordinates => getField<dynamic>('polygon_coordinates');
  set polygonCoordinates(dynamic value) => setField<dynamic>('polygon_coordinates', value);

  dynamic get priceMultiplier => getField<dynamic>('price_multiplier');
  set priceMultiplier(dynamic value) => setField<dynamic>('price_multiplier', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

}