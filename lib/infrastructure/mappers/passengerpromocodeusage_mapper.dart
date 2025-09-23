// lib/infrastructure/mappers/passengerpromocodeusage_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/passengerpromocodeusage.dart';
import '../../backend/supabase/database/tables/passenger_promo_code_usage.dart';


class PassengerPromoCodeUsageMapper {
  PassengerPromoCodeUsage toDomain(PassengerPromoCodeUsageRow row) {
    return PassengerPromoCodeUsage(
      id: row.id,
      userId: row.userId,
      promoCodeId: row.promoCodeId,
      tripId: row.tripId,
      originalAmount: row.originalAmount,
      discountAmount: row.discountAmount,
      finalAmount: row.finalAmount,
      usedAt: row.usedAt,
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
