// lib/domain/entities/driverapprovalaudit.dart


class DriverApprovalAudit {
  final String id;
  final String driverId;
  final String oldStatus;
  final String newStatus;
  final String reason;
  final dynamic approvedDocuments;
  final DateTime createdAt;

  const DriverApprovalAudit({
    required this.id,
    required this.driverId,
    required this.oldStatus,
    required this.newStatus,
    required this.reason,
    required this.approvedDocuments,
    required this.createdAt,
  });

  DriverApprovalAudit copyWith({
    String? id,
    String? driverId,
    String? oldStatus,
    String? newStatus,
    String? reason,
    dynamic approvedDocuments,
    DateTime? createdAt,
  }) {
    return DriverApprovalAudit(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      oldStatus: oldStatus ?? this.oldStatus,
      newStatus: newStatus ?? this.newStatus,
      reason: reason ?? this.reason,
      approvedDocuments: approvedDocuments ?? this.approvedDocuments,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DriverApprovalAudit &&
            other.id == this.id &&
            other.driverId == this.driverId &&
            other.oldStatus == this.oldStatus &&
            other.newStatus == this.newStatus &&
            other.reason == this.reason &&
            other.approvedDocuments == this.approvedDocuments &&
            other.createdAt == this.createdAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      driverId,
      oldStatus,
      newStatus,
      reason,
      approvedDocuments,
      createdAt,
    );
  }

  @override
  String toString() => 'DriverApprovalAudit(id: $id)';
}
