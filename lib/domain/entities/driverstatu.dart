// lib/domain/entities/driverstatu.dart


class DriverStatu {
  final String id;
  final String driverId;
  final bool onlineIntent;
  final DateTime updatedAt;

  const DriverStatu({
    required this.id,
    required this.driverId,
    required this.onlineIntent,
    required this.updatedAt,
  });

  DriverStatu copyWith({
    String? id,
    String? driverId,
    bool? onlineIntent,
    DateTime? updatedAt,
  }) {
    return DriverStatu(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      onlineIntent: onlineIntent ?? this.onlineIntent,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DriverStatu &&
            other.id == this.id &&
            other.driverId == this.driverId &&
            other.onlineIntent == this.onlineIntent &&
            other.updatedAt == this.updatedAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      driverId,
      onlineIntent,
      updatedAt,
    );
  }

  @override
  String toString() => 'DriverStatu(id: $id)';
}
