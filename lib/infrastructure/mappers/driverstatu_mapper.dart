// lib/infrastructure/mappers/driverstatu_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/driverstatu.dart';
import '../../backend/supabase/database/tables/driver_status.dart';


class DriverStatuMapper {
  DriverStatu toDomain(DriverStatusRow row) {
    return DriverStatu(
      driverId: row.driverId,
      onlineIntent: row.onlineIntent,
      updatedAt: row.updatedAt,
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
