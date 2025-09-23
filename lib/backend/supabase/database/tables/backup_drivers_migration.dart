import '../database.dart';

class BackupDriversMigrationTable extends SupabaseTable<BackupDriversMigrationRow> {
  @override
  String get tableName => 'backup_drivers_migration';

  @override
  BackupDriversMigrationRow createRow(Map<String, dynamic> data) => BackupDriversMigrationRow(data);
}

class BackupDriversMigrationRow extends SupabaseDataRow {
  BackupDriversMigrationRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BackupDriversMigrationTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get cnhNumber => getField<String>('cnh_number');
  set cnhNumber(String? value) => setField<String>('cnh_number', value);

  DateTime? get cnhExpiryDate => getField<DateTime>('cnh_expiry_date');
  set cnhExpiryDate(DateTime? value) => setField<DateTime>('cnh_expiry_date', value);

  String? get cnhPhotoUrl => getField<String>('cnh_photo_url');
  set cnhPhotoUrl(String? value) => setField<String>('cnh_photo_url', value);

  String? get vehicleBrand => getField<String>('vehicle_brand');
  set vehicleBrand(String? value) => setField<String>('vehicle_brand', value);

  String? get vehicleModel => getField<String>('vehicle_model');
  set vehicleModel(String? value) => setField<String>('vehicle_model', value);

  int? get vehicleYear => getField<int>('vehicle_year');
  set vehicleYear(int? value) => setField<int>('vehicle_year', value);

  String? get vehicleColor => getField<String>('vehicle_color');
  set vehicleColor(String? value) => setField<String>('vehicle_color', value);

  String? get vehiclePlate => getField<String>('vehicle_plate');
  set vehiclePlate(String? value) => setField<String>('vehicle_plate', value);

  String? get vehicleCategory => getField<String>('vehicle_category');
  set vehicleCategory(String? value) => setField<String>('vehicle_category', value);

  String? get crlvPhotoUrl => getField<String>('crlv_photo_url');
  set crlvPhotoUrl(String? value) => setField<String>('crlv_photo_url', value);

  String? get approvalStatus => getField<String>('approval_status');
  set approvalStatus(String? value) => setField<String>('approval_status', value);

  String? get approvedBy => getField<String>('approved_by');
  set approvedBy(String? value) => setField<String>('approved_by', value);

  DateTime? get approvedAt => getField<DateTime>('approved_at');
  set approvedAt(DateTime? value) => setField<DateTime>('approved_at', value);

  bool? get isOnline => getField<bool>('is_online');
  set isOnline(bool? value) => setField<bool>('is_online', value);

  bool? get acceptsPet => getField<bool>('accepts_pet');
  set acceptsPet(bool? value) => setField<bool>('accepts_pet', value);

  dynamic? get petFee => getField<dynamic>('pet_fee');
  set petFee(dynamic? value) => setField<dynamic>('pet_fee', value);

  bool? get acceptsGrocery => getField<bool>('accepts_grocery');
  set acceptsGrocery(bool? value) => setField<bool>('accepts_grocery', value);

  dynamic? get groceryFee => getField<dynamic>('grocery_fee');
  set groceryFee(dynamic? value) => setField<dynamic>('grocery_fee', value);

  bool? get acceptsCondo => getField<bool>('accepts_condo');
  set acceptsCondo(bool? value) => setField<bool>('accepts_condo', value);

  dynamic? get condoFee => getField<dynamic>('condo_fee');
  set condoFee(dynamic? value) => setField<dynamic>('condo_fee', value);

  dynamic? get stopFee => getField<dynamic>('stop_fee');
  set stopFee(dynamic? value) => setField<dynamic>('stop_fee', value);

  String? get acPolicy => getField<String>('ac_policy');
  set acPolicy(String? value) => setField<String>('ac_policy', value);

  dynamic? get customPricePerKm => getField<dynamic>('custom_price_per_km');
  set customPricePerKm(dynamic? value) => setField<dynamic>('custom_price_per_km', value);

  dynamic? get customPricePerMinute => getField<dynamic>('custom_price_per_minute');
  set customPricePerMinute(dynamic? value) => setField<dynamic>('custom_price_per_minute', value);

  String? get bankAccountType => getField<String>('bank_account_type');
  set bankAccountType(String? value) => setField<String>('bank_account_type', value);

  String? get bankCode => getField<String>('bank_code');
  set bankCode(String? value) => setField<String>('bank_code', value);

  String? get bankAgency => getField<String>('bank_agency');
  set bankAgency(String? value) => setField<String>('bank_agency', value);

  String? get bankAccount => getField<String>('bank_account');
  set bankAccount(String? value) => setField<String>('bank_account', value);

  String? get pixKey => getField<String>('pix_key');
  set pixKey(String? value) => setField<String>('pix_key', value);

  String? get pixKeyType => getField<String>('pix_key_type');
  set pixKeyType(String? value) => setField<String>('pix_key_type', value);

  int? get consecutiveCancellations => getField<int>('consecutive_cancellations');
  set consecutiveCancellations(int? value) => setField<int>('consecutive_cancellations', value);

  int? get totalTrips => getField<int>('total_trips');
  set totalTrips(int? value) => setField<int>('total_trips', value);

  dynamic? get averageRating => getField<dynamic>('average_rating');
  set averageRating(dynamic? value) => setField<dynamic>('average_rating', value);

  dynamic? get currentLatitude => getField<dynamic>('current_latitude');
  set currentLatitude(dynamic? value) => setField<dynamic>('current_latitude', value);

  dynamic? get currentLongitude => getField<dynamic>('current_longitude');
  set currentLongitude(dynamic? value) => setField<dynamic>('current_longitude', value);

  DateTime? get lastLocationUpdate => getField<DateTime>('last_location_update');
  set lastLocationUpdate(DateTime? value) => setField<DateTime>('last_location_update', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

}