import '../database.dart';

class PromoCodesTable extends SupabaseTable<PromoCodesRow> {
  @override
  String get tableName => 'promo_codes';

  @override
  PromoCodesRow createRow(Map<String, dynamic> data) => PromoCodesRow(data);
}

class PromoCodesRow extends SupabaseDataRow {
  PromoCodesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PromoCodesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get code => getField<String>('code');
  set code(String? value) => setField<String>('code', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get discountType => getField<String>('discount_type');
  set discountType(String? value) => setField<String>('discount_type', value);

  dynamic? get discountValue => getField<dynamic>('discount_value');
  set discountValue(dynamic? value) => setField<dynamic>('discount_value', value);

  dynamic? get maxDiscount => getField<dynamic>('max_discount');
  set maxDiscount(dynamic? value) => setField<dynamic>('max_discount', value);

  dynamic? get minTripValue => getField<dynamic>('min_trip_value');
  set minTripValue(dynamic? value) => setField<dynamic>('min_trip_value', value);

  int? get maxUsesPerUser => getField<int>('max_uses_per_user');
  set maxUsesPerUser(int? value) => setField<int>('max_uses_per_user', value);

  DateTime? get validFrom => getField<DateTime>('valid_from');
  set validFrom(DateTime? value) => setField<DateTime>('valid_from', value);

  DateTime? get validUntil => getField<DateTime>('valid_until');
  set validUntil(DateTime? value) => setField<DateTime>('valid_until', value);

  int? get usageLimit => getField<int>('usage_limit');
  set usageLimit(int? value) => setField<int>('usage_limit', value);

  int? get usedCount => getField<int>('used_count');
  set usedCount(int? value) => setField<int>('used_count', value);

  List<String> get targetCities => getListField<String>('target_cities');
  set targetCities(List<String>? value) => setListField<String>('target_cities', value);

  List<String> get targetCategories => getListField<String>('target_categories');
  set targetCategories(List<String>? value) => setListField<String>('target_categories', value);

  bool? get isFirstTripOnly => getField<bool>('is_first_trip_only');
  set isFirstTripOnly(bool? value) => setField<bool>('is_first_trip_only', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  String? get createdBy => getField<String>('created_by');
  set createdBy(String? value) => setField<String>('created_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

}