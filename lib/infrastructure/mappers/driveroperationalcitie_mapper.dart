// lib/infrastructure/mappers/driveroperationalcitie_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/driveroperationalcitie.dart';
import '../../backend/supabase/database/tables/driver_operational_cities.dart';


class DriverOperationalCitieMapper {
  DriverOperationalCitie toDomain(DriverOperationalCitiesRow row) {
    return DriverOperationalCitie(
      id: row.id,
      driverId: row.driverId,
      cityId: row.cityId,
      isPrimary: row.isPrimary,
      createdAt: row.createdAt,
    );
  }
  
  Map<String, dynamic> toSupabase(DriverOperationalCitie entity) {
    return {
      'id': entity.id,
      'driver_id': entity.driverId,
      'city_id': entity.cityId,
      'is_primary': entity.isPrimary,
      'created_at': entity.createdAt,
    };
  }

}
