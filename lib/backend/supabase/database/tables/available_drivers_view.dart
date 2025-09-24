import '../database.dart';
import '/backend/supabase/supabase.dart';

class AvailableDriversViewTable extends SupabaseTable<AvailableDriversViewRow> {
  @override
  String get tableName => 'available_drivers_view';

  @override
  AvailableDriversViewRow createRow(Map<String, dynamic> data) => AvailableDriversViewRow(data);
}

class AvailableDriversViewRow extends SupabaseDataRow {
  AvailableDriversViewRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AvailableDriversViewTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get driverId => getField<String>('driver_id')!;
  set driverId(String value) => setField<String>('driver_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get vehicleBrand => getField<String>('vehicle_brand')!;
  set vehicleBrand(String value) => setField<String>('vehicle_brand', value);

  String get vehicleModel => getField<String>('vehicle_model')!;
  set vehicleModel(String value) => setField<String>('vehicle_model', value);

  int get vehicleYear => getField<int>('vehicle_year')!;
  set vehicleYear(int value) => setField<int>('vehicle_year', value);

  String get vehicleColor => getField<String>('vehicle_color')!;
  set vehicleColor(String value) => setField<String>('vehicle_color', value);

  String get vehicleCategory => getField<String>('vehicle_category')!;
  set vehicleCategory(String value) => setField<String>('vehicle_category', value);

  String get vehiclePlate => getField<String>('vehicle_plate')!;
  set vehiclePlate(String value) => setField<String>('vehicle_plate', value);

  bool get isOnline => getField<bool>('is_online')!;
  set isOnline(bool value) => setField<bool>('is_online', value);

  bool get acceptsPet => getField<bool>('accepts_pet')!;
  set acceptsPet(bool value) => setField<bool>('accepts_pet', value);

  bool get acceptsGrocery => getField<bool>('accepts_grocery')!;
  set acceptsGrocery(bool value) => setField<bool>('accepts_grocery', value);

  bool get acceptsCondo => getField<bool>('accepts_condo')!;
  set acceptsCondo(bool value) => setField<bool>('accepts_condo', value);

  String get acPolicy => getField<String>('ac_policy')!;
  set acPolicy(String value) => setField<String>('ac_policy', value);

  dynamic get customPricePerKm => getField<dynamic>('custom_price_per_km');
  set customPricePerKm(dynamic value) => setField<dynamic>('custom_price_per_km', value);

  dynamic get petFee => getField<dynamic>('pet_fee');
  set petFee(dynamic value) => setField<dynamic>('pet_fee', value);

  dynamic get groceryFee => getField<dynamic>('grocery_fee');
  set groceryFee(dynamic value) => setField<dynamic>('grocery_fee', value);

  dynamic get condoFee => getField<dynamic>('condo_fee');
  set condoFee(dynamic value) => setField<dynamic>('condo_fee', value);

  dynamic get stopFee => getField<dynamic>('stop_fee');
  set stopFee(dynamic value) => setField<dynamic>('stop_fee', value);

  int get totalTrips => getField<int>('total_trips')!;
  set totalTrips(int value) => setField<int>('total_trips', value);

  double get averageRating => getField<double>('average_rating')!;
  set averageRating(double value) => setField<double>('average_rating', value);

  double? get currentLatitude => getField<double>('current_latitude');
  set currentLatitude(double? value) => setField<double>('current_latitude', value);

  double? get currentLongitude => getField<double>('current_longitude');
  set currentLongitude(double? value) => setField<double>('current_longitude', value);
}