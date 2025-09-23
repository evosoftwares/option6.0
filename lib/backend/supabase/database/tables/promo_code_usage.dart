import '../database.dart';

class PromoCodeUsageTable extends SupabaseTable<PromoCodeUsageRow> {
  @override
  String get tableName => 'promo_code_usage';

  @override
  PromoCodeUsageRow createRow(Map<String, dynamic> data) => PromoCodeUsageRow(data);
}

class PromoCodeUsageRow extends SupabaseDataRow {
  PromoCodeUsageRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PromoCodeUsageTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get promoCodeId => getField<String>('promo_code_id');
  set promoCodeId(String? value) => setField<String>('promo_code_id', value);

  String? get passengerId => getField<String>('passenger_id');
  set passengerId(String? value) => setField<String>('passenger_id', value);

  String? get tripId => getField<String>('trip_id');
  set tripId(String? value) => setField<String>('trip_id', value);

  dynamic? get discountApplied => getField<dynamic>('discount_applied');
  set discountApplied(dynamic? value) => setField<dynamic>('discount_applied', value);

  DateTime? get usedAt => getField<DateTime>('used_at');
  set usedAt(DateTime? value) => setField<DateTime>('used_at', value);

}