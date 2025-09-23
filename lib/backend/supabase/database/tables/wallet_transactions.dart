import '../database.dart';

class WalletTransactionsTable extends SupabaseTable<WalletTransactionsRow> {
  @override
  String get tableName => 'wallet_transactions';

  @override
  WalletTransactionsRow createRow(Map<String, dynamic> data) => WalletTransactionsRow(data);
}

class WalletTransactionsRow extends SupabaseDataRow {
  WalletTransactionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => WalletTransactionsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get walletId => getField<String>('wallet_id');
  set walletId(String? value) => setField<String>('wallet_id', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  dynamic? get amount => getField<dynamic>('amount');
  set amount(dynamic? value) => setField<dynamic>('amount', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get referenceType => getField<String>('reference_type');
  set referenceType(String? value) => setField<String>('reference_type', value);

  String? get referenceId => getField<String>('reference_id');
  set referenceId(String? value) => setField<String>('reference_id', value);

  dynamic? get balanceAfter => getField<dynamic>('balance_after');
  set balanceAfter(dynamic? value) => setField<dynamic>('balance_after', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

}