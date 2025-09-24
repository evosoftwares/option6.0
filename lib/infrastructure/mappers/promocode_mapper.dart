// lib/infrastructure/mappers/promocode_mapper.dart
import '../../domain/entities/promocode.dart';
import '../../backend/supabase/database/tables/promo_codes.dart';


class PromoCodeMapper {
  PromoCode toDomain(PromoCodesRow row) {
    return PromoCode(
      id: row.id,
      code: row.code ?? '',
      description: row.description ?? '',
      discountType: row.discountType ?? '',
      discountValue: row.discountValue ?? 0.0,
      maxDiscount: row.maxDiscount ?? 0.0,
      minTripValue: row.minTripValue ?? 0.0,
      maxUsesPerUser: row.maxUsesPerUser ?? 0,
      validFrom: row.validFrom ?? DateTime.now(),
      validUntil: row.validUntil ?? DateTime.now(),
      usageLimit: row.usageLimit ?? 0,
      usedCount: row.usedCount ?? 0,
      isFirstTripOnly: row.isFirstTripOnly ?? false,
      isActive: row.isActive ?? false,
      createdBy: row.createdBy ?? '',
      createdAt: row.createdAt ?? DateTime.now(),
      targetCities: row.targetCities,
      targetCategories: row.targetCategories,
    );
  }
  
  Map<String, dynamic> toSupabase(PromoCode entity) {
    return {
      'id': entity.id,
      'code': entity.code,
      'description': entity.description,
      'discount_type': entity.discountType,
      'discount_value': entity.discountValue,
      'max_discount': entity.maxDiscount,
      'min_trip_value': entity.minTripValue,
      'max_uses_per_user': entity.maxUsesPerUser,
      'valid_from': entity.validFrom,
      'valid_until': entity.validUntil,
      'usage_limit': entity.usageLimit,
      'used_count': entity.usedCount,
      'is_first_trip_only': entity.isFirstTripOnly,
      'is_active': entity.isActive,
      'created_by': entity.createdBy,
      'created_at': entity.createdAt,
      'target_cities': entity.targetCities,
      'target_categories': entity.targetCategories,
    };
  }
}
