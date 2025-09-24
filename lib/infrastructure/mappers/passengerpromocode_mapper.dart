// lib/infrastructure/mappers/passengerpromocode_mapper.dart
import '../../domain/entities/passengerpromocode.dart';
import '../../backend/supabase/database/tables/passenger_promo_codes.dart';


class PassengerPromoCodeMapper {
  PassengerPromoCode toDomain(PassengerPromoCodesRow row) {
    return PassengerPromoCode(
      id: row.id,
      code: row.code ?? '',
      type: row.type ?? '',
      value: row.value ?? 0.0,
      minAmount: row.minAmount ?? 0.0,
      maxDiscount: row.maxDiscount ?? 0.0,
      isActive: row.isActive ?? false,
      isFirstRideOnly: row.isFirstRideOnly ?? false,
      usageLimit: row.usageLimit ?? 0,
      usageCount: row.usageCount ?? 0,
      validFrom: row.validFrom ?? DateTime.now(),
      validUntil: row.validUntil ?? DateTime.now(),
      createdAt: row.createdAt ?? DateTime.now(),
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
