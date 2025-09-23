// lib/infrastructure/mappers/platformsetting_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/platformsetting.dart';
import '../../backend/supabase/database/tables/platform_settings.dart';
import '../../domain/value_objects/money.dart';

class PlatformSettingMapper {
  PlatformSetting toDomain(PlatformSettingsRow row) {
    return PlatformSetting(
      id: row.id,
      category: row.category,
      basePricePerKm: Money.fromReais(row.basePricePerKm ?? 0.0),
      basePricePerMinute: Money.fromReais(row.basePricePerMinute ?? 0.0),
      minFare: Money.fromReais(row.minFare ?? 0.0),
      minCancellationFee: Money.fromReais(row.minCancellationFee ?? 0.0),
      noShowWaitMinutes: row.noShowWaitMinutes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      searchRadiusKm: row.searchRadiusKm,
    );
  }
  
  Map<String, dynamic> toSupabase(PlatformSetting entity) {
    return {
      'id': entity.id,
      'category': entity.category,
      'base_price_per_km': entity.basePricePerKm.reais,
      'base_price_per_minute': entity.basePricePerMinute.reais,
      'min_fare': entity.minFare.reais,
      'min_cancellation_fee': entity.minCancellationFee.reais,
      'no_show_wait_minutes': entity.noShowWaitMinutes,
      'created_at': entity.createdAt,
      'updated_at': entity.updatedAt,
      'search_radius_km': entity.searchRadiusKm,
    };
  }

}
