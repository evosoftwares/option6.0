// lib/infrastructure/mappers/driveroperationzone_mapper.dart
import '../../domain/entities/driveroperationzone.dart';
import '../../backend/supabase/database/tables/driver_operation_zones.dart';
import '../../domain/value_objects/money.dart';

class DriverOperationZoneMapper {
  DriverOperationZone toDomain(DriverOperationZonesRow row) {
    return DriverOperationZone(
      id: row.id,
      driverId: row.driverId ?? '',
      zoneName: row.zoneName ?? '',
      polygonCoordinates: row.polygonCoordinates,
      priceMultiplier: Money.fromReais(row.priceMultiplier ?? 0.0),
      isActive: row.isActive ?? false,
      createdAt: row.createdAt ?? DateTime.now(),
      updatedAt: row.updatedAt ?? DateTime.now(),
    );
  }
  
  Map<String, dynamic> toSupabase(DriverOperationZone entity) {
    return {
      'id': entity.id,
      'driver_id': entity.driverId,
      'zone_name': entity.zoneName,
      'polygon_coordinates': entity.polygonCoordinates,
      'price_multiplier': entity.priceMultiplier.reais,
      'is_active': entity.isActive,
      'created_at': entity.createdAt,
      'updated_at': entity.updatedAt,
    };
  }

}
