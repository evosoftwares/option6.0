import '../database.dart';

class PlatformSettingsTable extends SupabaseTable<PlatformSettingsRow> {
  @override
  String get tableName => 'platform_settings';

  @override
  PlatformSettingsRow createRow(Map<String, dynamic> data) => PlatformSettingsRow(data);
}

class PlatformSettingsRow extends SupabaseDataRow {
  PlatformSettingsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PlatformSettingsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  dynamic get basePricePerKm => getField<dynamic>('base_price_per_km');
  set basePricePerKm(dynamic value) => setField<dynamic>('base_price_per_km', value);

  dynamic get basePricePerMinute => getField<dynamic>('base_price_per_minute');
  set basePricePerMinute(dynamic value) => setField<dynamic>('base_price_per_minute', value);

  dynamic get platformCommissionPercent => getField<dynamic>('platform_commission_percent');
  set platformCommissionPercent(dynamic value) => setField<dynamic>('platform_commission_percent', value);

  dynamic get minFare => getField<dynamic>('min_fare');
  set minFare(dynamic value) => setField<dynamic>('min_fare', value);

  dynamic get minCancellationFee => getField<dynamic>('min_cancellation_fee');
  set minCancellationFee(dynamic value) => setField<dynamic>('min_cancellation_fee', value);

  dynamic get cancellationFeePercent => getField<dynamic>('cancellation_fee_percent');
  set cancellationFeePercent(dynamic value) => setField<dynamic>('cancellation_fee_percent', value);

  int? get noShowWaitMinutes => getField<int>('no_show_wait_minutes');
  set noShowWaitMinutes(int? value) => setField<int>('no_show_wait_minutes', value);

  int? get driverAcceptanceTimeoutSeconds => getField<int>('driver_acceptance_timeout_seconds');
  set driverAcceptanceTimeoutSeconds(int? value) => setField<int>('driver_acceptance_timeout_seconds', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  int? get searchRadiusKm => getField<int>('search_radius_km');
  set searchRadiusKm(int? value) => setField<int>('search_radius_km', value);

}