// lib/infrastructure/mappers/passengerpromocode_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/passengerpromocode.dart';
import '../../backend/supabase/database/tables/passenger_promo_codes.dart';


class PassengerPromoCodeMapper {
  PassengerPromoCode toDomain(PassengerPromoCodesRow row) {
    return PassengerPromoCode(
      id: row.id,
      code: row.code,
      type: row.type,
      value: row.value,
      minAmount: row.minAmount,
      maxDiscount: row.maxDiscount,
      isActive: row.isActive,
      isFirstRideOnly: row.isFirstRideOnly,
      usageLimit: row.usageLimit,
      usageCount: row.usageCount,
      validFrom: row.validFrom,
      validUntil: row.validUntil,
      createdAt: row.createdAt,
    );
  }
  
  Map<String, dynamic> toSupabase(PassengerPromoCode entity) {
    return {
      'id': entity.id,
      'code': entity.code,
      'type': entity.type,
      'value': entity.value,
      'min_amount': entity.minAmount,
      'max_discount': entity.maxDiscount,
      'is_active': entity.isActive,
      'is_first_ride_only': entity.isFirstRideOnly,
      'usage_limit': entity.usageLimit,
      'usage_count': entity.usageCount,
      'valid_from': entity.validFrom,
      'valid_until': entity.validUntil,
      'created_at': entity.createdAt,
    };
  }

}
