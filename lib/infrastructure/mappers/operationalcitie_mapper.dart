// lib/infrastructure/mappers/operationalcitie_mapper.dart
import '../../domain/entities/operationalcitie.dart';
import '../../backend/supabase/database/tables/operational_cities.dart';
import '../../domain/value_objects/money.dart';

class OperationalCitieMapper {
  OperationalCitie toDomain(OperationalCitiesRow row) {
    return OperationalCitie(
      id: row.id,
      name: row.name ?? '',
      state: row.state ?? '',
      country: row.country ?? '',
      isActive: row.isActive ?? false,
      minFare: Money.fromReais(row.minFare ?? 0.0),
      launchDate: row.launchDate ?? DateTime.now(),
      polygonCoordinates: row.polygonCoordinates,
      createdAt: row.createdAt ?? DateTime.now(),
    );
  }
  
  Map<String, dynamic> toSupabase(OperationalCitie entity) {
    return {
      'id': entity.id,
      'name': entity.name,
      'state': entity.state,
      'country': entity.country,
      'is_active': entity.isActive,
      'min_fare': entity.minFare.reais,
      'launch_date': entity.launchDate,
      'polygon_coordinates': entity.polygonCoordinates,
      'created_at': entity.createdAt,
    };
  }

}
