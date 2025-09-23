// lib/domain/entities/tripstop.dart
import '../value_objects/location.dart';

class TripStop {
  final String id;
  final String tripId;
  final int stopOrder;
  final String address;
  final DateTime arrivedAt;
  final DateTime departedAt;
  final DateTime createdAt;
  final Location? locationLocation;

  const TripStop({
    required this.id,
    required this.tripId,
    required this.stopOrder,
    required this.address,
    required this.arrivedAt,
    required this.departedAt,
    required this.createdAt,
    this.locationLocation,
  });

  TripStop copyWith({
    String? id,
    String? tripId,
    int? stopOrder,
    String? address,
    DateTime? arrivedAt,
    DateTime? departedAt,
    DateTime? createdAt,
    Location? locationLocation,
  }) {
    return TripStop(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      stopOrder: stopOrder ?? this.stopOrder,
      address: address ?? this.address,
      arrivedAt: arrivedAt ?? this.arrivedAt,
      departedAt: departedAt ?? this.departedAt,
      createdAt: createdAt ?? this.createdAt,
      locationLocation: locationLocation ?? this.locationLocation,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TripStop &&
            other.id == this.id &&
            other.tripId == this.tripId &&
            other.stopOrder == this.stopOrder &&
            other.address == this.address &&
            other.arrivedAt == this.arrivedAt &&
            other.departedAt == this.departedAt &&
            other.createdAt == this.createdAt &&
            other.locationLocation == this.locationLocation);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      tripId,
      stopOrder,
      address,
      arrivedAt,
      departedAt,
      createdAt,
      locationLocation,
    );
  }

  @override
  String toString() => 'TripStop(id: $id)';
}
