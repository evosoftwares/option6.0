// lib/domain/entities/driverscheduleoverride.dart


class DriverScheduleOverride {
  final String id;
  final String driverId;
  final DateTime overrideStart;
  final DateTime overrideEnd;
  final bool isActive;
  final String reason;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DriverScheduleOverride({
    required this.id,
    required this.driverId,
    required this.overrideStart,
    required this.overrideEnd,
    required this.isActive,
    required this.reason,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  DriverScheduleOverride copyWith({
    String? id,
    String? driverId,
    DateTime? overrideStart,
    DateTime? overrideEnd,
    bool? isActive,
    String? reason,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DriverScheduleOverride(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      overrideStart: overrideStart ?? this.overrideStart,
      overrideEnd: overrideEnd ?? this.overrideEnd,
      isActive: isActive ?? this.isActive,
      reason: reason ?? this.reason,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DriverScheduleOverride &&
            other.id == this.id &&
            other.driverId == this.driverId &&
            other.overrideStart == this.overrideStart &&
            other.overrideEnd == this.overrideEnd &&
            other.isActive == this.isActive &&
            other.reason == this.reason &&
            other.createdBy == this.createdBy &&
            other.createdAt == this.createdAt &&
            other.updatedAt == this.updatedAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      driverId,
      overrideStart,
      overrideEnd,
      isActive,
      reason,
      createdBy,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() => 'DriverScheduleOverride(id: $id)';
}
