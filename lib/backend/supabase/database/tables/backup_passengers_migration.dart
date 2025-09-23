import '../database.dart';

class BackupPassengersMigrationTable extends SupabaseTable<BackupPassengersMigrationRow> {
  @override
  String get tableName => 'backup_passengers_migration';

  @override
  BackupPassengersMigrationRow createRow(Map<String, dynamic> data) => BackupPassengersMigrationRow(data);
}

class BackupPassengersMigrationRow extends SupabaseDataRow {
  BackupPassengersMigrationRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BackupPassengersMigrationTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

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

}