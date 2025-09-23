import '../database.dart';
import '/backend/supabase/supabase.dart';

class PassengersTable extends SupabaseTable<PassengersRow> {
  @override
  String get tableName => 'passengers';

  @override
  PassengersRow createRow(Map<String, dynamic> data) => PassengersRow(data);
}

class PassengersRow extends SupabaseDataRow {
  PassengersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PassengersTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  int? get consecutiveCancellations => getField<int>('consecutive_cancellations');
  set consecutiveCancellations(int? value) => setField<int>('consecutive_cancellations', value);

  int? get totalTrips => getField<int>('total_trips');
  set totalTrips(int? value) => setField<int>('total_trips', value);

  dynamic? get averageRating => getField<dynamic>('average_rating');
  set averageRating(dynamic? value) => setField<dynamic>('average_rating', value);

  String? get paymentMethodId => getField<String>('payment_method_id');
  set paymentMethodId(String? value) => setField<String>('payment_method_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

}