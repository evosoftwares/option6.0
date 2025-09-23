// lib/infrastructure/mappers/triplocationhistory_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/triplocationhistory.dart';
import '../../backend/supabase/database/tables/trip_location_history.dart';
import '../../domain/value_objects/location.dart';

class TripLocationHistoryMapper {
  TripLocationHistory toDomain(TripLocationHistoryRow row) {
    return TripLocationHistory(
      id: row.id,
      tripId: row.tripId,
      speedKmh: row.speedKmh,
      heading: row.heading,
      accuracyMeters: row.accuracyMeters,
      recordedAt: row.recordedAt,
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
