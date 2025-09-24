// lib/infrastructure/mappers/drivereffectivestatu_mapper.dart
import '../../domain/entities/drivereffectivestatu.dart';
import '../../backend/supabase/database/tables/driver_status.dart';


class DriverEffectiveStatuMapper {
  DriverEffectiveStatu toDomain(DriverStatusRow row) {
    return DriverEffectiveStatu(
      id: row.driverId, // Using driver_id as identifier since table has no separate id
      driverId: row.driverId,
      onlineIntent: row.onlineIntent ?? false,
      intentUpdatedAt: row.updatedAt ?? DateTime.now(),
      documentsValidated: false, // Not present in driver_status table; defaulting
      effectiveOnline: (row.onlineIntent ?? false), // Derived from online intent for now
    );
  }
  
  Map<String, dynamic> toSupabase(DriverEffectiveStatu entity) {
    return {
      'driver_id': entity.driverId,
      'online_intent': entity.onlineIntent,
      'updated_at': entity.intentUpdatedAt,
    };
  }

}
