// lib/infrastructure/mappers/triprequest_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/triprequest.dart';
import '../../backend/supabase/database/tables/trip_requests.dart';
import '../../domain/value_objects/location.dart';
import '../../domain/value_objects/money.dart';

class TripRequestMapper {
  TripRequest toDomain(TripRequestsRow row) {
    return TripRequest(
      id: row.id,
      passengerId: row.passengerId,
      originAddress: row.originAddress,
      originNeighborhood: row.originNeighborhood,
      destinationAddress: row.destinationAddress,
      vehicleCategory: row.vehicleCategory,
      needsPet: row.needsPet,
      needsGrocerySpace: row.needsGrocerySpace,
      needsAc: row.needsAc,
      isCondoOrigin: row.isCondoOrigin,
      isCondoDestination: row.isCondoDestination,
      numberOfStops: row.numberOfStops,
      status: row.status,
      selectedOfferId: row.selectedOfferId,
      createdAt: row.createdAt,
      expiresAt: row.expiresAt,
      targetDriverId: row.targetDriverId,
      acceptedByDriverId: row.acceptedByDriverId,
      acceptedAt: row.acceptedAt,
      currentFallbackIndex: row.currentFallbackIndex,
      timeoutCount: row.timeoutCount,
      estimatedDistanceKm: row.estimatedDistanceKm,
      estimatedFare: Money.fromReais(row.estimatedFare ?? 0.0),
      fallbackDrivers: row.fallbackDrivers,
      originLocation: row.originLatitude != null && row.originLongitude != null
          ? Location.fromCoordinates(row.originLatitude!, row.originLongitude!)
          : null,
      destinationLocation: row.destinationLatitude != null && row.destinationLongitude != null
          ? Location.fromCoordinates(row.destinationLatitude!, row.destinationLongitude!)
          : null,
    );
  }
  
  Map<String, dynamic> toSupabase(TripRequest entity) {
    return {
      'id': entity.id,
      'passenger_id': entity.passengerId,
      'origin_address': entity.originAddress,
      'origin_neighborhood': entity.originNeighborhood,
      'destination_address': entity.destinationAddress,
      'vehicle_category': entity.vehicleCategory,
      'needs_pet': entity.needsPet,
      'needs_grocery_space': entity.needsGrocerySpace,
      'needs_ac': entity.needsAc,
      'is_condo_origin': entity.isCondoOrigin,
      'is_condo_destination': entity.isCondoDestination,
      'number_of_stops': entity.numberOfStops,
      'status': entity.status,
      'selected_offer_id': entity.selectedOfferId,
      'created_at': entity.createdAt,
      'expires_at': entity.expiresAt,
      'target_driver_id': entity.targetDriverId,
      'accepted_by_driver_id': entity.acceptedByDriverId,
      'accepted_at': entity.acceptedAt,
      'current_fallback_index': entity.currentFallbackIndex,
      'timeout_count': entity.timeoutCount,
      'estimated_distance_km': entity.estimatedDistanceKm,
      'estimated_fare': entity.estimatedFare.reais,
      'fallback_drivers': entity.fallbackDrivers,
      'origin_latitude': entity.originLocation?.latitude,
      'origin_longitude': entity.originLocation?.longitude,
      'destination_latitude': entity.destinationLocation?.latitude,
      'destination_longitude': entity.destinationLocation?.longitude,
    };
  }

  List<T> _convertList<T>(List<dynamic>? list, T Function(dynamic) converter) {
    if (list == null) return [];
    return list.map(converter).toList();
  }
}
