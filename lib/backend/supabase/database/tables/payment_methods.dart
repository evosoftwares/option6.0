import '../database.dart';

class PaymentMethodsTable extends SupabaseTable<PaymentMethodsRow> {
  @override
  String get tableName => 'payment_methods';

  @override
  PaymentMethodsRow createRow(Map<String, dynamic> data) => PaymentMethodsRow(data);
}

class PaymentMethodsRow extends SupabaseDataRow {
  PaymentMethodsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PaymentMethodsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  dynamic? get type => getField<dynamic>('type');
  set type(dynamic? value) => setField<dynamic>('type', value);

  bool? get isDefault => getField<bool>('is_default');
  set isDefault(bool? value) => setField<bool>('is_default', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  dynamic? get cardData => getField<dynamic>('card_data');
  set cardData(dynamic? value) => setField<dynamic>('card_data', value);

  dynamic? get pixData => getField<dynamic>('pix_data');
  set pixData(dynamic? value) => setField<dynamic>('pix_data', value);

  dynamic? get asaasCustomerId => getField<dynamic>('asaas_customer_id');
  set asaasCustomerId(dynamic? value) => setField<dynamic>('asaas_customer_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

}