import '../database.dart';

class PassengerPromoCodeUsageTable extends SupabaseTable<PassengerPromoCodeUsageRow> {
  @override
  String get tableName => 'passenger_promo_code_usage';

  @override
  PassengerPromoCodeUsageRow createRow(Map<String, dynamic> data) => PassengerPromoCodeUsageRow(data);
}

class PassengerPromoCodeUsageRow extends SupabaseDataRow {
  PassengerPromoCodeUsageRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PassengerPromoCodeUsageTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get promoCodeId => getField<String>('promo_code_id');
  set promoCodeId(String? value) => setField<String>('promo_code_id', value);

  String? get tripId => getField<String>('trip_id');
  set tripId(String? value) => setField<String>('trip_id', value);

  dynamic? get originalAmount => getField<dynamic>('original_amount');
  set originalAmount(dynamic? value) => setField<dynamic>('original_amount', value);

  dynamic? get discountAmount => getField<dynamic>('discount_amount');
  set discountAmount(dynamic? value) => setField<dynamic>('discount_amount', value);

  dynamic? get finalAmount => getField<dynamic>('final_amount');
  set finalAmount(dynamic? value) => setField<dynamic>('final_amount', value);

  DateTime? get usedAt => getField<DateTime>('used_at');
  set usedAt(DateTime? value) => setField<DateTime>('used_at', value);

}