import '../database.dart';

class PassengerPromoCodesTable extends SupabaseTable<PassengerPromoCodesRow> {
  @override
  String get tableName => 'passenger_promo_codes';

  @override
  PassengerPromoCodesRow createRow(Map<String, dynamic> data) => PassengerPromoCodesRow(data);
}

class PassengerPromoCodesRow extends SupabaseDataRow {
  PassengerPromoCodesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PassengerPromoCodesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  dynamic get code => getField<dynamic>('code');
  set code(dynamic value) => setField<dynamic>('code', value);

  dynamic get type => getField<dynamic>('type');
  set type(dynamic value) => setField<dynamic>('type', value);

  dynamic get value => getField<dynamic>('value');
  set value(dynamic value) => setField<dynamic>('value', value);

  dynamic get minAmount => getField<dynamic>('min_amount');
  set minAmount(dynamic value) => setField<dynamic>('min_amount', value);

  dynamic get maxDiscount => getField<dynamic>('max_discount');
  set maxDiscount(dynamic value) => setField<dynamic>('max_discount', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  bool? get isFirstRideOnly => getField<bool>('is_first_ride_only');
  set isFirstRideOnly(bool? value) => setField<bool>('is_first_ride_only', value);

  int? get usageLimit => getField<int>('usage_limit');
  set usageLimit(int? value) => setField<int>('usage_limit', value);

  int? get usageCount => getField<int>('usage_count');
  set usageCount(int? value) => setField<int>('usage_count', value);

  DateTime? get validFrom => getField<DateTime>('valid_from');
  set validFrom(DateTime? value) => setField<DateTime>('valid_from', value);

  DateTime? get validUntil => getField<DateTime>('valid_until');
  set validUntil(DateTime? value) => setField<DateTime>('valid_until', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

}