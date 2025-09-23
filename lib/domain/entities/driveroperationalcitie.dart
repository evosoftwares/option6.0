// lib/domain/entities/driveroperationalcitie.dart


class DriverOperationalCitie {
  final String id;
  final String driverId;
  final String cityId;
  final bool isPrimary;
  final DateTime createdAt;

  const DriverOperationalCitie({
    required this.id,
    required this.driverId,
    required this.cityId,
    required this.isPrimary,
    required this.createdAt,
  });

  DriverOperationalCitie copyWith({
    String? id,
    String? driverId,
    String? cityId,
    bool? isPrimary,
    DateTime? createdAt,
  }) {
    return DriverOperationalCitie(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      cityId: cityId ?? this.cityId,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DriverOperationalCitie &&
            other.id == this.id &&
            other.driverId == this.driverId &&
            other.cityId == this.cityId &&
            other.isPrimary == this.isPrimary &&
            other.createdAt == this.createdAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      driverId,
      cityId,
      isPrimary,
      createdAt,
    );
  }

  @override
  String toString() => 'DriverOperationalCitie(id: $id)';
}
