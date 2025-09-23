// lib/domain/entities/activitylog.dart


class ActivityLog {
  final String id;
  final String userId;
  final String action;
  final String entityType;
  final String entityId;
  final dynamic oldValues;
  final dynamic newValues;
  final dynamic metadata;
  final String ipAddress;
  final String userAgent;
  final DateTime createdAt;

  const ActivityLog({
    required this.id,
    required this.userId,
    required this.action,
    required this.entityType,
    required this.entityId,
    required this.oldValues,
    required this.newValues,
    required this.metadata,
    required this.ipAddress,
    required this.userAgent,
    required this.createdAt,
  });

  ActivityLog copyWith({
    String? id,
    String? userId,
    String? action,
    String? entityType, String? entityId,
    dynamic oldValues,
    dynamic newValues,
    dynamic metadata,
    String? ipAddress,
    String? userAgent,
    DateTime? createdAt,
  }) {
    return ActivityLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      oldValues: oldValues ?? this.oldValues,
      newValues: newValues ?? this.newValues,
      metadata: metadata ?? this.metadata,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ActivityLog &&
            other.id == this.id &&
            other.userId == this.userId &&
            other.action == this.action &&
            other.entityType == this.entityType &&
            other.entityId == this.entityId &&
            other.oldValues == this.oldValues &&
            other.newValues == this.newValues &&
            other.metadata == this.metadata &&
            other.ipAddress == this.ipAddress &&
            other.userAgent == this.userAgent &&
            other.createdAt == this.createdAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      action,
      entityType,
      entityId,
      oldValues,
      newValues,
      metadata,
      ipAddress,
      userAgent,
      createdAt,
    );
  }

  @override
  String toString() => 'ActivityLog(id: $id)';
}
