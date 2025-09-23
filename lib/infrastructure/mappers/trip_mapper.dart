import '/backend/supabase/supabase.dart';
// lib/infrastructure/mappers/trip_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/trip.dart';
import '../../backend/supabase/database/tables/trips.dart';
import '../../domain/value_objects/location.dart';
import '../../domain/value_objects/money.dart';

class TripMapper {
  Trip toDomain(TripsRow row) {
    return Trip(
      id: row.id,
      tripCode: row.tripCode,
      requestId: row.requestId,
      passengerId: row.passengerId,
      driverId: row.driverId,
      status: row.status,
      originAddress: row.originAddress,
      originNeighborhood: row.originNeighborhood,
      destinationAddress: row.destinationAddress,
      vehicleCategory: row.vehicleCategory,
      needsPet: row.needsPet,
      needsGrocerySpace: row.needsGrocerySpace,
      isCondoDestination: row.isCondoDestination,
      isCondoOrigin: row.isCondoOrigin,
      needsAc: row.needsAc,
      numberOfStops: row.numberOfStops,
      routePolyline: row.routePolyline,
      estimatedDistanceKm: row.estimatedDistanceKm,
      actualDistanceKm: row.actualDistanceKm,
      actualDurationMinutes: row.actualDurationMinutes,
      waitingTimeMinutes: row.waitingTimeMinutes,
      baseFare: Money.fromReais(row.baseFare ?? 0.0),
      additionalFees: Money.fromReais(row.additionalFees ?? 0.0),
      surgeMultiplier: row.surgeMultiplier,
      totalFare: Money.fromReais(row.totalFare ?? 0.0),
      platformCommission: row.platformCommission,
      driverEarnings: row.driverEarnings,
      cancellationReason: row.cancellationReason,
      cancellationFee: Money.fromReais(row.cancellationFee ?? 0.0),
      cancelledBy: row.cancelledBy,
      createdAt: row.createdAt,
      driverAssignedAt: row.driverAssignedAt,
      driverArrivedAt: row.driverArrivedAt,
      tripStartedAt: row.tripStartedAt,
      tripCompletedAt: row.tripCompletedAt,
      cancelledAt: row.cancelledAt,
      paymentStatus: row.paymentStatus,
      paymentId: row.paymentId,
      promoCodeId: row.promoCodeId,
      discountApplied: row.discountApplied,
      updatedAt: row.updatedAt,
      startTime: row.startTime,
      endTime: row.endTime,
      requestedAt: row.requestedAt,
      completedAt: row.completedAt,
      assignedAt: row.assignedAt,
      arrivedAt: row.arrivedAt,
      originLocation: row.originLatitude != null && row.originLongitude != null
          ? Location.fromCoordinates(row.originLatitude!, row.originLongitude!)
          : null,
      destinationLocation: row.destinationLatitude != null && row.destinationLongitude != null
          ? Location.fromCoordinates(row.destinationLatitude!, row.destinationLongitude!)
          : null,
    );
  }
  
  Map<String, dynamic> toSupabase(Trip entity) {
    return {
      'id': entity.id,
      'trip_code': entity.tripCode,
      'request_id': entity.requestId,
      'passenger_id': entity.passengerId,
      'driver_id': entity.driverId,
      'status': entity.status,
      'origin_address': entity.originAddress,
      'origin_neighborhood': entity.originNeighborhood,
      'destination_address': entity.destinationAddress,
      'vehicle_category': entity.vehicleCategory,
      'needs_pet': entity.needsPet,
      'needs_grocery_space': entity.needsGrocerySpace,
      'is_condo_destination': entity.isCondoDestination,
      'is_condo_origin': entity.isCondoOrigin,
      'needs_ac': entity.needsAc,
      'number_of_stops': entity.numberOfStops,
      'route_polyline': entity.routePolyline,
      'estimated_distance_km': entity.estimatedDistanceKm,
      'actual_distance_km': entity.actualDistanceKm,
      'actual_duration_minutes': entity.actualDurationMinutes,
      'waiting_time_minutes': entity.waitingTimeMinutes,
      'base_fare': entity.baseFare.reais,
      'additional_fees': entity.additionalFees.reais,
      'surge_multiplier': entity.surgeMultiplier,
      'total_fare': entity.totalFare.reais,
      'platform_commission': entity.platformCommission,
      'driver_earnings': entity.driverEarnings,
      'cancellation_reason': entity.cancellationReason,
      'cancellation_fee': entity.cancellationFee.reais,
      'cancelled_by': entity.cancelledBy,
      'created_at': entity.createdAt,
      'driver_assigned_at': entity.driverAssignedAt,
      'driver_arrived_at': entity.driverArrivedAt,
      'trip_started_at': entity.tripStartedAt,
      'trip_completed_at': entity.tripCompletedAt,
      'cancelled_at': entity.cancelledAt,
      'payment_status': entity.paymentStatus,
      'payment_id': entity.paymentId,
      'promo_code_id': entity.promoCodeId,
      'discount_applied': entity.discountApplied,
      'updated_at': entity.updatedAt,
      'start_time': entity.startTime,
      'end_time': entity.endTime,
      'requested_at': entity.requestedAt,
      'completed_at': entity.completedAt,
      'assigned_at': entity.assignedAt,
      'arrived_at': entity.arrivedAt,
      'origin_latitude': entity.originLocation?.latitude,
      'origin_longitude': entity.originLocation?.longitude,
      'destination_latitude': entity.destinationLocation?.latitude,
      'destination_longitude': entity.destinationLocation?.longitude,
    };
  }

}
