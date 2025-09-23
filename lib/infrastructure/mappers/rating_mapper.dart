// lib/infrastructure/mappers/rating_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/rating.dart';
import '../../backend/supabase/database/tables/ratings.dart';


class RatingMapper {
  Rating toDomain(RatingsRow row) {
    return Rating(
      id: row.id,
      tripId: row.tripId,
      passengerRating: row.passengerRating,
      passengerRatedAt: row.passengerRatedAt,
      driverRating: row.driverRating,
      driverRatingComment: row.driverRatingComment,
      driverRatedAt: row.driverRatedAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      passengerRatingTags: row.passengerRatingTags,
      driverRatingTags: row.driverRatingTags,
    );
  }
  
  Map<String, dynamic> toSupabase(Rating entity) {
    return {
      'id': entity.id,
      'trip_id': entity.tripId,
      'passenger_rating': entity.passengerRating,
      'passenger_rated_at': entity.passengerRatedAt,
      'driver_rating': entity.driverRating,
      'driver_rating_comment': entity.driverRatingComment,
      'driver_rated_at': entity.driverRatedAt,
      'created_at': entity.createdAt,
      'updated_at': entity.updatedAt,
      'passenger_rating_tags': entity.passengerRatingTags,
      'driver_rating_tags': entity.driverRatingTags,
    };
  }

  List<T> _convertList<T>(List<dynamic>? list, T Function(dynamic) converter) {
    if (list == null) return [];
    return list.map(converter).toList();
  }
}
