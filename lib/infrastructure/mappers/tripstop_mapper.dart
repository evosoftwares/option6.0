// lib/infrastructure/mappers/tripstop_mapper.dart
import '../../domain/entities/tripstop.dart';
import '../../backend/supabase/database/tables/trip_stops.dart';
import '../../domain/value_objects/location.dart';

class TripStopMapper {
  TripStop toDomain(TripStopsRow row) {
    return TripStop(
      id: row.id,
      tripId: row.tripId ?? '',
      stopOrder: row.stopOrder ?? 0,
      address: row.address ?? '',
      arrivedAt: row.arrivedAt ?? DateTime.now(),
      departedAt: row.departedAt ?? DateTime.now(),
      createdAt: row.createdAt ?? DateTime.now(),
      locationLocation: row.latitude != null && row.longitude != null
          ? Location.fromCoordinates(row.latitude!, row.longitude!)
          : null,
    );
  }
  
  Map<String, dynamic> toSupabase(TripStop entity) {
    return {
      'id': entity.id,
      'trip_id': entity.tripId,
      'stop_order': entity.stopOrder,
      'address': entity.address,
      'arrived_at': entity.arrivedAt,
      'departed_at': entity.departedAt,
      'created_at': entity.createdAt,
      'latitude': entity.locationLocation?.latitude,
      'longitude': entity.locationLocation?.longitude,
    };
  }

}
