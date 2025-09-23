// lib/domain/entities/driverexcludedzone.dart


class DriverExcludedZone {
  final String id;
  final String driverId;
  final String type;
  final String localName;
  final DateTime createdAt;

  const DriverExcludedZone({
    required this.id,
    required this.driverId,
    required this.type,
    required this.localName,
    required this.createdAt,
  });

  DriverExcludedZone copyWith({
    String? id,
    String? driverId,
    String? type,
    String? localName,
    DateTime? createdAt,
  }) {
    return DriverExcludedZone(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      type: type ?? this.type,
      localName: localName ?? this.localName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DriverExcludedZone &&
            other.id == this.id &&
            other.driverId == this.driverId &&
            other.type == this.type &&
            other.localName == this.localName &&
            other.createdAt == this.createdAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      driverId,
      type,
      localName,
      createdAt,
    );
  }

  @override
  String toString() => 'DriverExcludedZone(id: $id)';
}
