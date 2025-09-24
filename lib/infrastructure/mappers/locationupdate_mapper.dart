// lib/infrastructure/mappers/locationupdate_mapper.dart
import '../../domain/entities/locationupdate.dart';
import '../../backend/supabase/database/tables/location_updates.dart';
import '../../domain/value_objects/location.dart';

class LocationUpdateMapper {
  LocationUpdate toDomain(LocationUpdatesRow row) {
    return LocationUpdate(
      id: row.id,
      sharingId: row.sharingId ?? '',
      timestamp: row.timestamp ?? DateTime.now(),
      locationLocation: row.latitude != null && row.longitude != null
          ? Location.fromCoordinates(row.latitude!, row.longitude!)
          : null,
    );
  }
  
  Map<String, dynamic> toSupabase(LocationUpdate entity) {
    return {
      'id': entity.id,
      'sharing_id': entity.sharingId,
      'timestamp': entity.timestamp,
      'latitude': entity.locationLocation?.latitude,
      'longitude': entity.locationLocation?.longitude,
    };
  }

}
