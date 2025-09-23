// lib/domain/entities/tripstatushistory.dart


class TripStatusHistory {
  final String id;
  final String tripId;
  final String oldStatus;
  final String newStatus;
  final String changedBy;
  final String reason;
  final dynamic metadata;
  final DateTime createdAt;

  const TripStatusHistory({
    required this.id,
    required this.tripId,
    required this.oldStatus,
    required this.newStatus,
    required this.changedBy,
    required this.reason,
    required this.metadata,
    required this.createdAt,
  });

  TripStatusHistory copyWith({
    String? id,
    String? tripId,
    String? oldStatus,
    String? newStatus,
    String? changedBy,
    String? reason,
    dynamic metadata,
    DateTime? createdAt,
  }) {
    return TripStatusHistory(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      oldStatus: oldStatus ?? this.oldStatus,
      newStatus: newStatus ?? this.newStatus,
      changedBy: changedBy ?? this.changedBy,
      reason: reason ?? this.reason,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TripStatusHistory &&
            other.id == this.id &&
            other.tripId == this.tripId &&
            other.oldStatus == this.oldStatus &&
            other.newStatus == this.newStatus &&
            other.changedBy == this.changedBy &&
            other.reason == this.reason &&
            other.metadata == this.metadata &&
            other.createdAt == this.createdAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      tripId,
      oldStatus,
      newStatus,
      changedBy,
      reason,
      metadata,
      createdAt,
    );
  }

  @override
  String toString() => 'TripStatusHistory(id: $id)';
}
