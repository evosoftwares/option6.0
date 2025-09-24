// lib/infrastructure/mappers/passengerpromocodeusage_mapper.dart
import '../../domain/entities/passengerpromocodeusage.dart';
import '../../backend/supabase/database/tables/passenger_promo_code_usage.dart';


class PassengerPromoCodeUsageMapper {
  PassengerPromoCodeUsage toDomain(PassengerPromoCodeUsageRow row) {
    return PassengerPromoCodeUsage(
      id: row.id,
      userId: row.userId ?? '',
      promoCodeId: row.promoCodeId ?? '',
      tripId: row.tripId ?? '',
      originalAmount: row.originalAmount ?? 0.0,
      discountAmount: row.discountAmount ?? 0.0,
      finalAmount: row.finalAmount ?? 0.0,
      usedAt: row.usedAt ?? DateTime.now(),
    );
  }
  
  Map<String, dynamic> toSupabase(PassengerPromoCodeUsage entity) {
    return {
      'id': entity.id,
      'user_id': entity.userId,
      'promo_code_id': entity.promoCodeId,
      'trip_id': entity.tripId,
      'original_amount': entity.originalAmount,
      'discount_amount': entity.discountAmount,
      'final_amount': entity.finalAmount,
      'used_at': entity.usedAt,
    };
  }

}
