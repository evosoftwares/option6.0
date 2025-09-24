// lib/infrastructure/mappers/triplocationhistory_mapper.dart
import '../../domain/entities/triplocationhistory.dart';
import '../../backend/supabase/database/tables/trip_location_history.dart';
import '../../domain/value_objects/location.dart';

class TripLocationHistoryMapper {
  TripLocationHistory toDomain(TripLocationHistoryRow row) {
    return TripLocationHistory(
      id: row.id,
      tripId: row.tripId ?? '',
      speedKmh: row.speedKmh ?? 0.0,
      heading: row.heading ?? 0.0,
      accuracyMeters: row.accuracyMeters ?? 0.0,
      recordedAt: row.recordedAt ?? DateTime.now(),
      locationLocation: row.latitude != null && row.longitude != null
          ? Location.fromCoordinates(row.latitude!, row.longitude!)
          : null,
    );
  }
  
  Map<String, dynamic> toSupabase(TripLocationHistory entity) {
    return {
      'id': entity.id,
      'trip_id': entity.tripId,
      'speed_kmh': entity.speedKmh,
      'heading': entity.heading,
      'accuracy_meters': entity.accuracyMeters,
      'recorded_at': entity.recordedAt,
      'latitude': entity.locationLocation?.latitude,
      'longitude': entity.locationLocation?.longitude,
    };
  }

}
