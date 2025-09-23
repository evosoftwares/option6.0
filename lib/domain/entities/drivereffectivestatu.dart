// lib/domain/entities/drivereffectivestatu.dart


class DriverEffectiveStatu {
  final String id;
  final String driverId;
  final bool onlineIntent;
  final DateTime intentUpdatedAt;
  final bool documentsValidated;
  final bool effectiveOnline;

  const DriverEffectiveStatu({
    required this.id,
    required this.driverId,
    required this.onlineIntent,
    required this.intentUpdatedAt,
    required this.documentsValidated,
    required this.effectiveOnline,
  });

  DriverEffectiveStatu copyWith({
    String? id,
    String? driverId,
    bool? onlineIntent,
    DateTime? intentUpdatedAt,
    bool? documentsValidated,
    bool? effectiveOnline,
  }) {
    return DriverEffectiveStatu(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      onlineIntent: onlineIntent ?? this.onlineIntent,
      intentUpdatedAt: intentUpdatedAt ?? this.intentUpdatedAt,
      documentsValidated: documentsValidated ?? this.documentsValidated,
      effectiveOnline: effectiveOnline ?? this.effectiveOnline,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DriverEffectiveStatu &&
            other.id == this.id &&
            other.driverId == this.driverId &&
            other.onlineIntent == this.onlineIntent &&
            other.intentUpdatedAt == this.intentUpdatedAt &&
            other.documentsValidated == this.documentsValidated &&
            other.effectiveOnline == this.effectiveOnline);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      driverId,
      onlineIntent,
      intentUpdatedAt,
      documentsValidated,
      effectiveOnline,
    );
  }

  @override
  String toString() => 'DriverEffectiveStatu(id: $id)';
}
