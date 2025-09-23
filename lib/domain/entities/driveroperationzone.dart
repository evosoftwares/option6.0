// lib/domain/entities/driveroperationzone.dart
import '../value_objects/money.dart';

class DriverOperationZone {
  final String id;
  final String driverId;
  final String zoneName;
  final dynamic polygonCoordinates;
  final Money priceMultiplier;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DriverOperationZone({
    required this.id,
    required this.driverId,
    required this.zoneName,
    required this.polygonCoordinates,
    required this.priceMultiplier,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  DriverOperationZone copyWith({
    String? id,
    String? driverId,
    String? zoneName,
    dynamic polygonCoordinates,
    Money? priceMultiplier,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DriverOperationZone(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      zoneName: zoneName ?? this.zoneName,
      polygonCoordinates: polygonCoordinates ?? this.polygonCoordinates,
      priceMultiplier: priceMultiplier ?? this.priceMultiplier,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DriverOperationZone &&
            other.id == this.id &&
            other.driverId == this.driverId &&
            other.zoneName == this.zoneName &&
            other.polygonCoordinates == this.polygonCoordinates &&
            other.priceMultiplier == this.priceMultiplier &&
            other.isActive == this.isActive &&
            other.createdAt == this.createdAt &&
            other.updatedAt == this.updatedAt);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      driverId,
      zoneName,
      polygonCoordinates,
      priceMultiplier,
      isActive,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() => 'DriverOperationZone(id: $id)';
}
