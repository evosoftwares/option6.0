// lib/infrastructure/mappers/driverscheduleoverride_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/driverscheduleoverride.dart';
import '../../backend/supabase/database/tables/driver_schedule_overrides.dart';


class DriverScheduleOverrideMapper {
  DriverScheduleOverride toDomain(DriverScheduleOverridesRow row) {
    return DriverScheduleOverride(
      id: row.id,
      driverId: row.driverId,
      overrideStart: row.overrideStart,
      overrideEnd: row.overrideEnd,
      isActive: row.isActive,
      reason: row.reason,
      createdBy: row.createdBy,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
  
  Map<String, dynamic> toSupabase(DriverScheduleOverride entity) {
    return {
      'id': entity.id,
      'driver_id': entity.driverId,
      'override_start': entity.overrideStart,
      'override_end': entity.overrideEnd,
      'is_active': entity.isActive,
      'reason': entity.reason,
      'created_by': entity.createdBy,
      'created_at': entity.createdAt,
      'updated_at': entity.updatedAt,
    };
  }

}
