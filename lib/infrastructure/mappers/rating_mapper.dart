// lib/infrastructure/mappers/rating_mapper.dart
import '../../domain/entities/rating.dart';
import '../../backend/supabase/database/tables/ratings.dart';


class RatingMapper {
  Rating toDomain(RatingsRow row) {
    return Rating(
      id: row.id,
      tripId: row.tripId ?? '',
      passengerRating: row.passengerRating ?? 0,
      passengerRatedAt: row.passengerRatedAt ?? DateTime.now(),
      driverRating: row.driverRating ?? 0,
      driverRatingComment: row.driverRatingComment ?? '',
      driverRatedAt: row.driverRatedAt ?? DateTime.now(),
      createdAt: row.createdAt ?? DateTime.now(),
      updatedAt: row.updatedAt ?? DateTime.now(),
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
}
