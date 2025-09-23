// lib/infrastructure/mappers/locationsharing_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/locationsharing.dart';
import '../../backend/supabase/database/tables/location_sharing.dart';


class LocationSharingMapper {
  LocationSharing toDomain(LocationSharingRow row) {
    return LocationSharing(
      id: row.id,
      userId: row.userId,
      expiresAt: row.expiresAt,
      isActive: row.isActive,
      createdAt: row.createdAt,
      endedAt: row.endedAt,
      sharedWithUsers: row.sharedWithUsers,
    );
  }
  
  Map<String, dynamic> toSupabase(LocationSharing entity) {
    return {
      'id': entity.id,
      'user_id': entity.userId,
      'expires_at': entity.expiresAt,
      'is_active': entity.isActive,
      'created_at': entity.createdAt,
      'ended_at': entity.endedAt,
      'shared_with_users': entity.sharedWithUsers,
    };
  }

  List<T> _convertList<T>(List<dynamic>? list, T Function(dynamic) converter) {
    if (list == null) return [];
    return list.map(converter).toList();
  }
}
