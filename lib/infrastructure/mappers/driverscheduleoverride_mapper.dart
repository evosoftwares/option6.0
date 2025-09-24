// lib/infrastructure/mappers/driverscheduleoverride_mapper.dart
import '../../domain/entities/driverscheduleoverride.dart';
import '../../backend/supabase/database/tables/driver_schedule_overrides.dart';


class DriverScheduleOverrideMapper {
  DriverScheduleOverride toDomain(DriverScheduleOverridesRow row) {
    return DriverScheduleOverride(
      id: row.id,
      driverId: row.driverId ?? '',
      overrideStart: row.overrideStart ?? DateTime.now(),
      overrideEnd: row.overrideEnd ?? DateTime.now(),
      isActive: row.isActive ?? false,
      reason: row.reason ?? '',
      createdBy: row.createdBy ?? '',
      createdAt: row.createdAt ?? DateTime.now(),
      updatedAt: row.updatedAt ?? DateTime.now(),
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
