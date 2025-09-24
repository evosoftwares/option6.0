import '/backend/supabase/supabase.dart';
// lib/infrastructure/mappers/passenger_mapper.dart
import '../../domain/entities/passenger.dart';
import '../../backend/supabase/database/tables/passengers.dart';
import '../../domain/value_objects/email.dart';

class PassengerMapper {
  Passenger toDomain(PassengersRow row) {
    return Passenger(
      id: row.id,
      userId: row.userId ?? '',
      totalTrips: row.totalTrips ?? 0,
      consecutiveCancellations: row.consecutiveCancellations ?? 0,
      averageRating: row.averageRating ?? 0.0,
      paymentMethodId: row.paymentMethodId ?? '',
      createdAt: row.createdAt ?? DateTime.now(),
      updatedAt: row.updatedAt ?? DateTime.now(),
      email: Email(row.email ?? ''),
    );
  }
  
  Map<String, dynamic> toSupabase(Passenger entity) {
    return {
      'id': entity.id,
      'user_id': entity.userId,
      'total_trips': entity.totalTrips,
      'average_rating': entity.averageRating,
      'payment_method_id': entity.paymentMethodId,
      'created_at': entity.createdAt,
      'updated_at': entity.updatedAt,
      'email': entity.email.value,
    };
  }

}
