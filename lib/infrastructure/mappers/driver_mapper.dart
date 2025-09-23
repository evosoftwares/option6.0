import '/backend/supabase/supabase.dart';
// lib/infrastructure/mappers/driver_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/driver.dart';
import '../../backend/supabase/database/tables/drivers.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/location.dart';
import '../../domain/value_objects/money.dart';

class DriverMapper {
  Driver toDomain(DriversRow row) {
    return Driver(
      id: row.id,
      userId: row.userId,
      vehicleBrand: row.vehicleBrand,
      vehicleModel: row.vehicleModel,
      vehicleYear: row.vehicleYear,
      vehicleColor: row.vehicleColor,
      vehiclePlate: row.vehiclePlate,
      vehicleCategory: row.vehicleCategory,
      approvedBy: row.approvedBy,
      approvedAt: row.approvedAt,
      isOnline: row.isOnline,
      acceptsPet: row.acceptsPet,
      petFee: Money.fromReais(row.petFee ?? 0.0),
      acceptsGrocery: row.acceptsGrocery,
      groceryFee: Money.fromReais(row.groceryFee ?? 0.0),
      acceptsCondo: row.acceptsCondo,
      condoFee: Money.fromReais(row.condoFee ?? 0.0),
      stopFee: Money.fromReais(row.stopFee ?? 0.0),
      acPolicy: row.acPolicy,
      customPricePerKm: Money.fromReais(row.customPricePerKm ?? 0.0),
      bankAccountType: row.bankAccountType,
      bankCode: row.bankCode,
      bankAgency: row.bankAgency,
      bankAccount: row.bankAccount,
      pixKey: row.pixKey,
      pixKeyType: row.pixKeyType,
      totalTrips: row.totalTrips,
      averageRating: row.averageRating,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      fcmToken: row.fcmToken,
      devicePlatform: row.devicePlatform,
      approvalStatus: row.approvalStatus,
      onesignalPlayerId: row.onesignalPlayerId,
      email: Email(row.email!),
      currentLocation: row.currentLatitude != null && row.currentLongitude != null
          ? Location.fromCoordinates(row.currentLatitude!, row.currentLongitude!)
          : null,
    );
  }
  
  Map<String, dynamic> toSupabase(Driver entity) {
    return {
      'id': entity.id,
      'user_id': entity.userId,
      'vehicle_brand': entity.vehicleBrand,
      'vehicle_model': entity.vehicleModel,
      'vehicle_year': entity.vehicleYear,
      'vehicle_color': entity.vehicleColor,
      'vehicle_plate': entity.vehiclePlate,
      'vehicle_category': entity.vehicleCategory,
      'approved_by': entity.approvedBy,
      'approved_at': entity.approvedAt,
      'is_online': entity.isOnline,
      'accepts_pet': entity.acceptsPet,
      'pet_fee': entity.petFee.reais,
      'accepts_grocery': entity.acceptsGrocery,
      'grocery_fee': entity.groceryFee.reais,
      'accepts_condo': entity.acceptsCondo,
      'condo_fee': entity.condoFee.reais,
      'stop_fee': entity.stopFee.reais,
      'ac_policy': entity.acPolicy,
      'custom_price_per_km': entity.customPricePerKm.reais,
      'bank_account_type': entity.bankAccountType,
      'bank_code': entity.bankCode,
      'bank_agency': entity.bankAgency,
      'bank_account': entity.bankAccount,
      'pix_key': entity.pixKey,
      'pix_key_type': entity.pixKeyType,
      'total_trips': entity.totalTrips,
      'average_rating': entity.averageRating,
      'created_at': entity.createdAt,
      'updated_at': entity.updatedAt,
      'fcm_token': entity.fcmToken,
      'device_platform': entity.devicePlatform,
      'approval_status': entity.approvalStatus,
      'onesignal_player_id': entity.onesignalPlayerId,
      'email': entity.email.value,
      'current_latitude': entity.currentLocation?.latitude,
      'current_longitude': entity.currentLocation?.longitude,
    };
  }

}
