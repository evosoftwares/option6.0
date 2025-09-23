// lib/infrastructure/mappers/savedplace_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/savedplace.dart';
import '../../backend/supabase/database/tables/saved_places.dart';
import '../../domain/value_objects/location.dart';

class SavedPlaceMapper {
  SavedPlace toDomain(SavedPlacesRow row) {
    return SavedPlace(
      id: row.id,
      userId: row.userId,
      label: row.label,
      address: row.address,
      category: row.category,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      locationLocation: row.latitude != null && row.longitude != null
          ? Location.fromCoordinates(row.latitude!, row.longitude!)
          : null,
    );
  }
  
  Map<String, dynamic> toSupabase(SavedPlace entity) {
    return {
      'id': entity.id,
      'user_id': entity.userId,
      'label': entity.label,
      'address': entity.address,
      'category': entity.category,
      'created_at': entity.createdAt,
      'updated_at': entity.updatedAt,
      'latitude': entity.locationLocation?.latitude,
      'longitude': entity.locationLocation?.longitude,
    };
  }

}
