import '../database.dart';

class PassengerWalletTransactionsTable extends SupabaseTable<PassengerWalletTransactionsRow> {
  @override
  String get tableName => 'passenger_wallet_transactions';

  @override
  PassengerWalletTransactionsRow createRow(Map<String, dynamic> data) => PassengerWalletTransactionsRow(data);
}

class PassengerWalletTransactionsRow extends SupabaseDataRow {
  PassengerWalletTransactionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PassengerWalletTransactionsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get walletId => getField<String>('wallet_id');
  set walletId(String? value) => setField<String>('wallet_id', value);

  String? get passengerId => getField<String>('passenger_id');
  set passengerId(String? value) => setField<String>('passenger_id', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  dynamic get amount => getField<dynamic>('amount');
  set amount(dynamic value) => setField<dynamic>('amount', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get tripId => getField<String>('trip_id');
  set tripId(String? value) => setField<String>('trip_id', value);

  String? get paymentMethodId => getField<String>('payment_method_id');
  set paymentMethodId(String? value) => setField<String>('payment_method_id', value);

  String? get asaasPaymentId => getField<String>('asaas_payment_id');
  set asaasPaymentId(String? value) => setField<String>('asaas_payment_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  dynamic get metadata => getField<dynamic>('metadata');
  set metadata(dynamic value) => setField<dynamic>('metadata', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get processedAt => getField<DateTime>('processed_at');
  set processedAt(DateTime? value) => setField<DateTime>('processed_at', value);

}