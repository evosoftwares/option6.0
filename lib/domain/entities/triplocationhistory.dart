// lib/domain/entities/triplocationhistory.dart
import '../value_objects/location.dart';

class TripLocationHistory {
  final String id;
  final String tripId;
  final double speedKmh;
  final double heading;
  final double accuracyMeters;
  final DateTime recordedAt;
  final Location? locationLocation;

  const TripLocationHistory({
    required this.id,
    required this.tripId,
    required this.speedKmh,
    required this.heading,
    required this.accuracyMeters,
    required this.recordedAt,
    this.locationLocation,
  });

  TripLocationHistory copyWith({
    String? id,
    String? tripId,
    double? speedKmh,
    double? heading,
    double? accuracyMeters,
    DateTime? recordedAt,
    Location? locationLocation,
  }) {
    return TripLocationHistory(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      speedKmh: speedKmh ?? this.speedKmh,
      heading: heading ?? this.heading,
      accuracyMeters: accuracyMeters ?? this.accuracyMeters,
      recordedAt: recordedAt ?? this.recordedAt,
      locationLocation: locationLocation ?? this.locationLocation,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TripLocationHistory &&
            other.id == this.id &&
            other.tripId == this.tripId &&
            other.speedKmh == this.speedKmh &&
            other.heading == this.heading &&
            other.accuracyMeters == this.accuracyMeters &&
            other.recordedAt == this.recordedAt &&
            other.locationLocation == this.locationLocation);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      tripId,
      speedKmh,
      heading,
      accuracyMeters,
      recordedAt,
      locationLocation,
    );
  }

  @override
  String toString() => 'TripLocationHistory(id: $id)';
}
