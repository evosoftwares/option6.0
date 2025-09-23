import '../database.dart';

class DriverApprovalAuditTable extends SupabaseTable<DriverApprovalAuditRow> {
  @override
  String get tableName => 'driver_approval_audit';

  @override
  DriverApprovalAuditRow createRow(Map<String, dynamic> data) => DriverApprovalAuditRow(data);
}

class DriverApprovalAuditRow extends SupabaseDataRow {
  DriverApprovalAuditRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DriverApprovalAuditTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get driverId => getField<String>('driver_id');
  set driverId(String? value) => setField<String>('driver_id', value);

  String? get oldStatus => getField<String>('old_status');
  set oldStatus(String? value) => setField<String>('old_status', value);

  String? get newStatus => getField<String>('new_status');
  set newStatus(String? value) => setField<String>('new_status', value);

  String? get reason => getField<String>('reason');
  set reason(String? value) => setField<String>('reason', value);

  List<dynamic> get approvedDocuments => getListField<dynamic>('approved_documents');
  set approvedDocuments(List<dynamic>? value) => setListField<dynamic>('approved_documents', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

}