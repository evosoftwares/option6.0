import '../database.dart';

class BackupPassengersBeforeFkChangeTable extends SupabaseTable<BackupPassengersBeforeFkChangeRow> {
  @override
  String get tableName => 'backup_passengers_before_fk_change';

  @override
  BackupPassengersBeforeFkChangeRow createRow(Map<String, dynamic> data) => BackupPassengersBeforeFkChangeRow(data);
}

class BackupPassengersBeforeFkChangeRow extends SupabaseDataRow {
  BackupPassengersBeforeFkChangeRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BackupPassengersBeforeFkChangeTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  int? get consecutiveCancellations => getField<int>('consecutive_cancellations');
  set consecutiveCancellations(int? value) => setField<int>('consecutive_cancellations', value);

  int? get totalTrips => getField<int>('total_trips');
  set totalTrips(int? value) => setField<int>('total_trips', value);

  dynamic get averageRating => getField<dynamic>('average_rating');
  set averageRating(dynamic value) => setField<dynamic>('average_rating', value);

  String? get paymentMethodId => getField<String>('payment_method_id');
  set paymentMethodId(String? value) => setField<String>('payment_method_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

}