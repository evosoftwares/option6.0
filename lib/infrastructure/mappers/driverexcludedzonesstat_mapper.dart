// lib/infrastructure/mappers/driverexcludedzonesstat_mapper.dart
import '../../domain/entities/driverexcludedzonesstat.dart';
import '../../backend/supabase/database/tables/driver_excluded_zones.dart';


class DriverExcludedZonesStatMapper {
  DriverExcludedZonesStat toDomain(DriverExcludedZonesRow row) {
    return DriverExcludedZonesStat(
      id: row.id,
      driverId: row.driverId ?? '',
      totalExcludedZones: 1,
      lastExclusionDate: row.createdAt ?? DateTime.now(),
      cities: row.localName != null ? [row.localName!] : [],
      states: const [],
    );
  }
  
  Map<String, dynamic> toSupabase(DriverExcludedZonesStat entity) {
    // Since stats entity aggregates multiple rows, insert a minimal representation
    return {
      'driver_id': entity.driverId,
      'type': 'aggregated',
      'local_name': entity.cities.isNotEmpty ? entity.cities.first : null,
      'created_at': entity.lastExclusionDate.toIso8601String(),
    };
  }
}
