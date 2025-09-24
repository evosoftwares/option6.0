// lib/infrastructure/mappers/availabledriversview_mapper.dart
import '../../domain/entities/availabledriversview.dart';
import '../../backend/supabase/database/tables/available_drivers_view.dart';
import '../../domain/value_objects/location.dart';
import '../../domain/value_objects/money.dart';

class AvailableDriversViewMapper {
  AvailableDriversView toDomain(AvailableDriversViewRow row) {
    return AvailableDriversView(
      id: row.id,
      driverId: row.driverId,
      userId: row.userId,
      vehicleBrand: row.vehicleBrand,
      vehicleModel: row.vehicleModel,
      vehicleYear: row.vehicleYear,
      vehicleColor: row.vehicleColor,
      vehicleCategory: row.vehicleCategory,
      vehiclePlate: row.vehiclePlate,
      isOnline: row.isOnline,
      acceptsPet: row.acceptsPet,
      acceptsGrocery: row.acceptsGrocery,
      acceptsCondo: row.acceptsCondo,
      acPolicy: row.acPolicy,
      customPricePerKm: Money.fromReais(row.customPricePerKm ?? 0.0),
      petFee: Money.fromReais(row.petFee ?? 0.0),
      groceryFee: Money.fromReais(row.groceryFee ?? 0.0),
      condoFee: Money.fromReais(row.condoFee ?? 0.0),
      stopFee: Money.fromReais(row.stopFee ?? 0.0),
      totalTrips: row.totalTrips,
      averageRating: row.averageRating,
      currentLocation: row.currentLatitude != null && row.currentLongitude != null
          ? Location.fromCoordinates(row.currentLatitude!, row.currentLongitude!)
          : null,
    );
  }
  
  Map<String, dynamic> toSupabase(AvailableDriversView entity) {
    return {
      'id': entity.id,
      'driver_id': entity.driverId,
      'user_id': entity.userId,
      'vehicle_brand': entity.vehicleBrand,
      'vehicle_model': entity.vehicleModel,
      'vehicle_year': entity.vehicleYear,
      'vehicle_color': entity.vehicleColor,
      'vehicle_category': entity.vehicleCategory,
      'vehicle_plate': entity.vehiclePlate,
      'is_online': entity.isOnline,
      'accepts_pet': entity.acceptsPet,
      'accepts_grocery': entity.acceptsGrocery,
      'accepts_condo': entity.acceptsCondo,
      'ac_policy': entity.acPolicy,
      'custom_price_per_km': entity.customPricePerKm.reais,
      'pet_fee': entity.petFee.reais,
      'grocery_fee': entity.groceryFee.reais,
      'condo_fee': entity.condoFee.reais,
      'stop_fee': entity.stopFee.reais,
      'total_trips': entity.totalTrips,
      'average_rating': entity.averageRating,
      'current_latitude': entity.currentLocation?.latitude,
      'current_longitude': entity.currentLocation?.longitude,
    };
  }

}
