import '../database.dart';

class WithdrawalsTable extends SupabaseTable<WithdrawalsRow> {
  @override
  String get tableName => 'withdrawals';

  @override
  WithdrawalsRow createRow(Map<String, dynamic> data) => WithdrawalsRow(data);
}

class WithdrawalsRow extends SupabaseDataRow {
  WithdrawalsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => WithdrawalsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get driverId => getField<String>('driver_id');
  set driverId(String? value) => setField<String>('driver_id', value);

  String? get walletId => getField<String>('wallet_id');
  set walletId(String? value) => setField<String>('wallet_id', value);

  dynamic? get amount => getField<dynamic>('amount');
  set amount(dynamic? value) => setField<dynamic>('amount', value);

  String? get withdrawalMethod => getField<String>('withdrawal_method');
  set withdrawalMethod(String? value) => setField<String>('withdrawal_method', value);

  List<dynamic> get bankAccountInfo => getListField<dynamic>('bank_account_info');
  set bankAccountInfo(List<dynamic>? value) => setListField<dynamic>('bank_account_info', value);

  String? get asaasTransferId => getField<String>('asaas_transfer_id');
  set asaasTransferId(String? value) => setField<String>('asaas_transfer_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get failureReason => getField<String>('failure_reason');
  set failureReason(String? value) => setField<String>('failure_reason', value);

  DateTime? get requestedAt => getField<DateTime>('requested_at');
  set requestedAt(DateTime? value) => setField<DateTime>('requested_at', value);

  DateTime? get processedAt => getField<DateTime>('processed_at');
  set processedAt(DateTime? value) => setField<DateTime>('processed_at', value);

  DateTime? get completedAt => getField<DateTime>('completed_at');
  set completedAt(DateTime? value) => setField<DateTime>('completed_at', value);

}