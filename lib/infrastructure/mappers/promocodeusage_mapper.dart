// lib/infrastructure/mappers/promocodeusage_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/promocodeusage.dart';
import '../../backend/supabase/database/tables/promo_code_usage.dart';


class PromoCodeUsageMapper {
  PromoCodeUsage toDomain(PromoCodeUsageRow row) {
    return PromoCodeUsage(
      id: row.id,
      promoCodeId: row.promoCodeId,
      passengerId: row.passengerId,
      tripId: row.tripId,
      discountApplied: row.discountApplied,
      usedAt: row.usedAt,
    );
  }
  
  Map<String, dynamic> toSupabase(PromoCodeUsage entity) {
    return {
      'id': entity.id,
      'promo_code_id': entity.promoCodeId,
      'passenger_id': entity.passengerId,
      'trip_id': entity.tripId,
      'discount_applied': entity.discountApplied,
      'used_at': entity.usedAt,
    };
  }

}
