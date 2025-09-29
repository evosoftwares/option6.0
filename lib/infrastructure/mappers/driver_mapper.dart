import '/backend/supabase/supabase.dart';
// lib/infrastructure/mappers/driver_mapper.dart
import '../../domain/entities/driver.dart';
import '../../backend/supabase/database/tables/drivers.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/location.dart';
import '../../domain/value_objects/money.dart';

class DriverMapper {
  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  Driver toDomain(DriversRow row) {
    return Driver(
      id: row.id,
      userId: row.userId,
      vehicleBrand: row.vehicleBrand ?? '',
      vehicleModel: row.vehicleModel ?? '',
      vehicleYear: row.vehicleYear ?? 0,
      vehicleColor: row.vehicleColor ?? '',
      vehiclePlate: row.vehiclePlate ?? '',
      vehicleCategory: row.vehicleCategory ?? '',
      approvedBy: row.approvedBy ?? '',
      approvedAt: row.approvedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      isOnline: row.isOnline ?? false,
      acceptsPet: row.acceptsPet ?? false,
      petFee: Money.fromReais(_toDouble(row.petFee)),
      acceptsGrocery: row.acceptsGrocery ?? false,
      groceryFee: Money.fromReais(_toDouble(row.groceryFee)),
      acceptsCondo: row.acceptsCondo ?? false,
      condoFee: Money.fromReais(_toDouble(row.condoFee)),
      stopFee: Money.fromReais(_toDouble(row.stopFee)),
      acPolicy: row.acPolicy ?? '',
      customPricePerKm: Money.fromReais(_toDouble(row.customPricePerKm)),
      bankAccountType: row.bankAccountType ?? '',
      bankCode: row.bankCode ?? '',
      bankAgency: row.bankAgency ?? '',
      bankAccount: row.bankAccount ?? '',
      pixKey: row.pixKey ?? '',
      pixKeyType: row.pixKeyType ?? '',
      totalTrips: row.totalTrips ?? 0,
      averageRating: _toDouble(row.averageRating),
      createdAt: row.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: row.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      fcmToken: row.fcmToken ?? '',
      devicePlatform: row.devicePlatform ?? '',
      approvalStatus: row.approvalStatus?.toString() ?? '',
      onesignalPlayerId: row.onesignalPlayerId,
      email: Email(row.email ?? 'placeholder@example.com'),
      currentLocation: row.currentLatitude != null && row.currentLongitude != null
          ? Location.fromCoordinates(
              _toDouble(row.currentLatitude),
              _toDouble(row.currentLongitude),
            )
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
