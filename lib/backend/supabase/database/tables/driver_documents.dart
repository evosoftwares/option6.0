import '../database.dart';

class DriverDocumentsTable extends SupabaseTable<DriverDocumentsRow> {
  @override
  String get tableName => 'driver_documents';

  @override
  DriverDocumentsRow createRow(Map<String, dynamic> data) => DriverDocumentsRow(data);
}

class DriverDocumentsRow extends SupabaseDataRow {
  DriverDocumentsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DriverDocumentsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get driverId => getField<String>('driver_id');
  set driverId(String? value) => setField<String>('driver_id', value);

  String? get documentType => getField<String>('document_type');
  set documentType(String? value) => setField<String>('document_type', value);

  String? get fileUrl => getField<String>('file_url');
  set fileUrl(String? value) => setField<String>('file_url', value);

  int? get fileSize => getField<int>('file_size');
  set fileSize(int? value) => setField<int>('file_size', value);

  String? get mimeType => getField<String>('mime_type');
  set mimeType(String? value) => setField<String>('mime_type', value);

  DateTime? get expiryDate => getField<DateTime>('expiry_date');
  set expiryDate(DateTime? value) => setField<DateTime>('expiry_date', value);

  String? get rejectionReason => getField<String>('rejection_reason');
  set rejectionReason(String? value) => setField<String>('rejection_reason', value);

  String? get reviewedBy => getField<String>('reviewed_by');
  set reviewedBy(String? value) => setField<String>('reviewed_by', value);

  DateTime? get reviewedAt => getField<DateTime>('reviewed_at');
  set reviewedAt(DateTime? value) => setField<DateTime>('reviewed_at', value);

  bool? get isCurrent => getField<bool>('is_current');
  set isCurrent(bool? value) => setField<bool>('is_current', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  dynamic get status => getField<dynamic>('status');
  set status(dynamic value) => setField<dynamic>('status', value);

}