import '../database.dart';
import '/backend/supabase/supabase.dart';

class DriverWalletsTable extends SupabaseTable<DriverWalletsRow> {
  @override
  String get tableName => 'driver_wallets';

  @override
  DriverWalletsRow createRow(Map<String, dynamic> data) => DriverWalletsRow(data);
}

class DriverWalletsRow extends SupabaseDataRow {
  DriverWalletsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DriverWalletsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get driverId => getField<String>('driver_id');
  set driverId(String? value) => setField<String>('driver_id', value);

  dynamic get availableBalance => getField<dynamic>('available_balance');
  set availableBalance(dynamic value) => setField<dynamic>('available_balance', value);

  dynamic get pendingBalance => getField<dynamic>('pending_balance');
  set pendingBalance(dynamic value) => setField<dynamic>('pending_balance', value);

  dynamic get totalEarned => getField<dynamic>('total_earned');
  set totalEarned(dynamic value) => setField<dynamic>('total_earned', value);

  dynamic get totalWithdrawn => getField<dynamic>('total_withdrawn');
  set totalWithdrawn(dynamic value) => setField<dynamic>('total_withdrawn', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

}