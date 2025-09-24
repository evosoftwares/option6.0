// lib/infrastructure/mappers/driverexcludedzone_mapper.dart
import '../../domain/entities/driverexcludedzone.dart';
import '../../backend/supabase/database/tables/driver_excluded_zones.dart';


class DriverExcludedZoneMapper {
  DriverExcludedZone toDomain(DriverExcludedZonesRow row) {
    return DriverExcludedZone(
      id: row.id,
      driverId: row.driverId ?? '',
      type: row.type ?? '',
      localName: row.localName ?? '',
      createdAt: row.createdAt ?? DateTime.now(),
    );
  }
  
  Map<String, dynamic> toSupabase(DriverExcludedZone entity) {
    return {
      'id': entity.id,
      'driver_id': entity.driverId,
      'type': entity.type,
      'local_name': entity.localName,
      'created_at': entity.createdAt,
    };
  }

}
