// lib/domain/entities/locationupdate.dart
import '../value_objects/location.dart';

class LocationUpdate {
  final String id;
  final String sharingId;
  final DateTime timestamp;
  final Location? locationLocation;

  const LocationUpdate({
    required this.id,
    required this.sharingId,
    required this.timestamp,
    this.locationLocation,
  });

  LocationUpdate copyWith({
    String? id, String? sharingId,
    DateTime? timestamp,
    Location? locationLocation,
  }) {
    return LocationUpdate(
      id: id ?? this.id,
      sharingId: sharingId ?? this.sharingId,
      timestamp: timestamp ?? this.timestamp,
      locationLocation: locationLocation ?? this.locationLocation,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LocationUpdate &&
            other.id == this.id &&
            other.sharingId == this.sharingId &&
            other.timestamp == this.timestamp &&
            other.locationLocation == this.locationLocation);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      sharingId,
      timestamp,
      locationLocation,
    );
  }

  @override
  String toString() => 'LocationUpdate(id: $id)';
}
