// lib/domain/entities/securityalert.dart


class SecurityAlert {
  final String id;
  final String alertType;
  final String severity;
  final String description;
  final dynamic metadata;
  final bool resolved;
  final DateTime resolvedAt;
  final String resolvedBy;
  final DateTime createdAt;

  const SecurityAlert({
    required this.id,
    required this.alertType,
    required this.severity,
    required this.description,
    required this.metadata,
    required this.resolved,
    required this.resolvedAt,
    required this.resolvedBy,
    required this.createdAt,
  });

  SecurityAlert copyWith({
    String? id,
    String? alertType,
    String? severity,
    String? description,
    dynamic metadata,
    bool? resolved,
    DateTime? resolvedAt,
    String? resolvedBy,
    DateTime? createdAt,
  }) {
    return SecurityAlert(
      id: id ?? this.id,
      alertType: alertType ?? this.alertType,
      severity: severity ?? this.severity,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
      resolved: resolved ?? this.resolved,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is SecurityAlert &&
            other.id == this.id &&
            other.alertType == this.alertType &&
            other.severity == this.severity &&
            other.description == this.description &&
            other.metadata == this.metadata &&
            other.resolved == this.resolved &&
            other.resolvedAt == this.resolvedAt &&
            other.resolvedBy == this.resolvedBy &&
            other.createdAt == this.createdAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      alertType,
      severity,
      description,
      metadata,
      resolved,
      resolvedAt,
      resolvedBy,
      createdAt,
    );
  }

  @override
  String toString() => 'SecurityAlert(id: $id)';
}
