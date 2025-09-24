// lib/infrastructure/mappers/driverstatu_mapper.dart
import '../../domain/entities/driverstatu.dart';
import '../../backend/supabase/database/tables/driver_status.dart';


class DriverStatuMapper {
  DriverStatu toDomain(DriverStatusRow row) {
    return DriverStatu(
      id: row.driverId,
      driverId: row.driverId,
      onlineIntent: row.onlineIntent ?? false,
      updatedAt: row.updatedAt ?? DateTime.now(),
    );
  }
  
  Map<String, dynamic> toSupabase(DriverStatu entity) {
    return {
      'driver_id': entity.driverId,
      'online_intent': entity.onlineIntent,
      'updated_at': entity.updatedAt,
    };
  }

}
