// lib/infrastructure/mappers/backupdriversmigration_mapper.dart
import '../../domain/entities/backupdriversmigration.dart';
import '../../backend/supabase/database/tables/backup_drivers_migration.dart';
import '../../domain/value_objects/location.dart';
import '../../domain/value_objects/money.dart';
import '../../utils/num_utils.dart';

class BackupDriversMigrationMapper {
  BackupDriversMigration toDomain(BackupDriversMigrationRow row) {
    return BackupDriversMigration(
      id: row.id,
      userId: row.userId ?? '',
      cnhNumber: row.cnhNumber ?? '',
      cnhExpiryDate: row.cnhExpiryDate ?? DateTime.now(),
      cnhPhotoUrl: row.cnhPhotoUrl ?? '',
      vehicleBrand: row.vehicleBrand ?? '',
      vehicleModel: row.vehicleModel ?? '',
      vehicleYear: row.vehicleYear ?? 0,
      vehicleColor: row.vehicleColor ?? '',
      vehiclePlate: row.vehiclePlate ?? '',
      vehicleCategory: row.vehicleCategory ?? '',
      crlvPhotoUrl: row.crlvPhotoUrl ?? '',
      approvalStatus: row.approvalStatus ?? '',
      approvedBy: row.approvedBy ?? '',
      approvedAt: row.approvedAt ?? DateTime.now(),
      isOnline: row.isOnline ?? false,
      acceptsPet: row.acceptsPet ?? false,
      petFee: Money.fromReais(row.petFee ?? 0.0),
      acceptsGrocery: row.acceptsGrocery ?? false,
      groceryFee: Money.fromReais(row.groceryFee ?? 0.0),
      acceptsCondo: row.acceptsCondo ?? false,
      condoFee: Money.fromReais(row.condoFee ?? 0.0),
      stopFee: Money.fromReais(row.stopFee ?? 0.0),
      acPolicy: row.acPolicy ?? '',
      customPricePerKm: Money.fromReais(row.customPricePerKm ?? 0.0),
      bankAccountType: row.bankAccountType ?? '',
      bankCode: row.bankCode ?? '',
      bankAgency: row.bankAgency ?? '',
      bankAccount: row.bankAccount ?? '',
      pixKey: row.pixKey ?? '',
      pixKeyType: row.pixKeyType ?? '',
      totalTrips: row.totalTrips ?? 0,
      averageRating: row.averageRating ?? 0.0,
      createdAt: row.createdAt ?? DateTime.now(),
      updatedAt: row.updatedAt ?? DateTime.now(),
      currentLocation: toDoubleOrNull(row.currentLatitude) != null && toDoubleOrNull(row.currentLongitude) != null
          ? Location.fromCoordinates(
              toDoubleOrNull(row.currentLatitude)!,
              toDoubleOrNull(row.currentLongitude)!,
            )
          : null,
    );
  }
  
  Map<String, dynamic> toSupabase(BackupDriversMigration entity) {
    return {
      'id': entity.id,
      'user_id': entity.userId,
      'cnh_number': entity.cnhNumber,
      'cnh_expiry_date': entity.cnhExpiryDate,
      'cnh_photo_url': entity.cnhPhotoUrl,
      'vehicle_brand': entity.vehicleBrand,
      'vehicle_model': entity.vehicleModel,
      'vehicle_year': entity.vehicleYear,
      'vehicle_color': entity.vehicleColor,
      'vehicle_plate': entity.vehiclePlate,
      'vehicle_category': entity.vehicleCategory,
      'crlv_photo_url': entity.crlvPhotoUrl,
      'approval_status': entity.approvalStatus,
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
      'current_latitude': entity.currentLocation?.latitude,
      'current_longitude': entity.currentLocation?.longitude,
    };
  }

}
