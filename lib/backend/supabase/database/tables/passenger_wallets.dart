import '../database.dart';

class PassengerWalletsTable extends SupabaseTable<PassengerWalletsRow> {
  @override
  String get tableName => 'passenger_wallets';

  @override
  PassengerWalletsRow createRow(Map<String, dynamic> data) => PassengerWalletsRow(data);
}

class PassengerWalletsRow extends SupabaseDataRow {
  PassengerWalletsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PassengerWalletsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get passengerId => getField<String>('passenger_id');
  set passengerId(String? value) => setField<String>('passenger_id', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  dynamic? get availableBalance => getField<dynamic>('available_balance');
  set availableBalance(dynamic? value) => setField<dynamic>('available_balance', value);

  dynamic? get pendingBalance => getField<dynamic>('pending_balance');
  set pendingBalance(dynamic? value) => setField<dynamic>('pending_balance', value);

  dynamic? get totalSpent => getField<dynamic>('total_spent');
  set totalSpent(dynamic? value) => setField<dynamic>('total_spent', value);

  dynamic? get totalCashback => getField<dynamic>('total_cashback');
  set totalCashback(dynamic? value) => setField<dynamic>('total_cashback', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

}