// lib/domain/entities/backupdriversmigration.dart
import '../value_objects/location.dart';
import '../value_objects/money.dart';

class BackupDriversMigration {
  final String id;
  final String userId;
  final String cnhNumber;
  final DateTime cnhExpiryDate;
  final String cnhPhotoUrl;
  final String vehicleBrand;
  final String vehicleModel;
  final int vehicleYear;
  final String vehicleColor;
  final String vehiclePlate;
  final String vehicleCategory;
  final String crlvPhotoUrl;
  final String approvalStatus;
  final String approvedBy;
  final DateTime approvedAt;
  final bool isOnline;
  final bool acceptsPet;
  final Money petFee;
  final bool acceptsGrocery;
  final Money groceryFee;
  final bool acceptsCondo;
  final Money condoFee;
  final Money stopFee;
  final String acPolicy;
  final Money customPricePerKm;
  final String bankAccountType;
  final String bankCode;
  final String bankAgency;
  final String bankAccount;
  final String pixKey;
  final String pixKeyType;
  final int totalTrips;
  final double averageRating;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Location? currentLocation;

  const BackupDriversMigration({
    required this.id,
    required this.userId,
    required this.cnhNumber,
    required this.cnhExpiryDate,
    required this.cnhPhotoUrl,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.vehicleYear,
    required this.vehicleColor,
    required this.vehiclePlate,
    required this.vehicleCategory,
    required this.crlvPhotoUrl,
    required this.approvalStatus,
    required this.approvedBy,
    required this.approvedAt,
    required this.isOnline,
    required this.acceptsPet,
    required this.petFee,
    required this.acceptsGrocery,
    required this.groceryFee,
    required this.acceptsCondo,
    required this.condoFee,
    required this.stopFee,
    required this.acPolicy,
    required this.customPricePerKm,
    required this.bankAccountType,
    required this.bankCode,
    required this.bankAgency,
    required this.bankAccount,
    required this.pixKey,
    required this.pixKeyType,
    required this.totalTrips,
    required this.averageRating,
    required this.createdAt,
    required this.updatedAt,
    this.currentLocation,
  });

  BackupDriversMigration copyWith({
    String? id,
    String? userId,
    String? cnhNumber,
    DateTime? cnhExpiryDate,
    String? cnhPhotoUrl,
    String? vehicleBrand,
    String? vehicleModel,
    int? vehicleYear,
    String? vehicleColor,
    String? vehiclePlate,
    String? vehicleCategory,
    String? crlvPhotoUrl,
    String? approvalStatus,
    String? approvedBy,
    DateTime? approvedAt,
    bool? isOnline,
    bool? acceptsPet,
    Money? petFee,
    bool? acceptsGrocery,
    Money? groceryFee,
    bool? acceptsCondo,
    Money? condoFee,
    Money? stopFee,
    String? acPolicy,
    Money? customPricePerKm,
    String? bankAccountType,
    String? bankCode,
    String? bankAgency,
    String? bankAccount,
    String? pixKey,
    String? pixKeyType,
    int? totalTrips,
    double? averageRating,
    DateTime? createdAt,
    DateTime? updatedAt,
    Location? currentLocation,
  }) {
    return BackupDriversMigration(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cnhNumber: cnhNumber ?? this.cnhNumber,
      cnhExpiryDate: cnhExpiryDate ?? this.cnhExpiryDate,
      cnhPhotoUrl: cnhPhotoUrl ?? this.cnhPhotoUrl,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleYear: vehicleYear ?? this.vehicleYear,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      vehicleCategory: vehicleCategory ?? this.vehicleCategory,
      crlvPhotoUrl: crlvPhotoUrl ?? this.crlvPhotoUrl,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      isOnline: isOnline ?? this.isOnline,
      acceptsPet: acceptsPet ?? this.acceptsPet,
      petFee: petFee ?? this.petFee,
      acceptsGrocery: acceptsGrocery ?? this.acceptsGrocery,
      groceryFee: groceryFee ?? this.groceryFee,
      acceptsCondo: acceptsCondo ?? this.acceptsCondo,
      condoFee: condoFee ?? this.condoFee,
      stopFee: stopFee ?? this.stopFee,
      acPolicy: acPolicy ?? this.acPolicy,
      customPricePerKm: customPricePerKm ?? this.customPricePerKm,
      bankAccountType: bankAccountType ?? this.bankAccountType,
      bankCode: bankCode ?? this.bankCode,
      bankAgency: bankAgency ?? this.bankAgency,
      bankAccount: bankAccount ?? this.bankAccount,
      pixKey: pixKey ?? this.pixKey,
      pixKeyType: pixKeyType ?? this.pixKeyType,
      totalTrips: totalTrips ?? this.totalTrips,
      averageRating: averageRating ?? this.averageRating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      currentLocation: currentLocation ?? this.currentLocation,
    );
  }

  // Business methods can be added here

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is BackupDriversMigration &&
            other.id == this.id &&
            other.userId == this.userId &&
            other.cnhNumber == this.cnhNumber &&
            other.cnhExpiryDate == this.cnhExpiryDate &&
            other.cnhPhotoUrl == this.cnhPhotoUrl &&
            other.vehicleBrand == this.vehicleBrand &&
            other.vehicleModel == this.vehicleModel &&
            other.vehicleYear == this.vehicleYear &&
            other.vehicleColor == this.vehicleColor &&
            other.vehiclePlate == this.vehiclePlate &&
            other.vehicleCategory == this.vehicleCategory &&
            other.crlvPhotoUrl == this.crlvPhotoUrl &&
            other.approvalStatus == this.approvalStatus &&
            other.approvedBy == this.approvedBy &&
            other.approvedAt == this.approvedAt &&
            other.isOnline == this.isOnline &&
            other.acceptsPet == this.acceptsPet &&
            other.petFee == this.petFee &&
            other.acceptsGrocery == this.acceptsGrocery &&
            other.groceryFee == this.groceryFee &&
            other.acceptsCondo == this.acceptsCondo &&
            other.condoFee == this.condoFee &&
            other.stopFee == this.stopFee &&
            other.acPolicy == this.acPolicy &&
            other.customPricePerKm == this.customPricePerKm &&
            other.bankAccountType == this.bankAccountType &&
            other.bankCode == this.bankCode &&
            other.bankAgency == this.bankAgency &&
            other.bankAccount == this.bankAccount &&
            other.pixKey == this.pixKey &&
            other.pixKeyType == this.pixKeyType &&
            other.totalTrips == this.totalTrips &&
            other.averageRating == this.averageRating &&
            other.createdAt == this.createdAt &&
            other.updatedAt == this.updatedAt &&
            other.currentLocation == this.currentLocation);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      cnhNumber,
      cnhExpiryDate,
      cnhPhotoUrl,
      vehicleBrand,
      vehicleModel,
      vehicleYear,
      vehicleColor,
      vehiclePlate,
      vehicleCategory,
      crlvPhotoUrl,
      approvalStatus,
      approvedBy,
      approvedAt,
      isOnline,
      acceptsPet,
      petFee,
      acceptsGrocery,
      Object.hashAll([
        groceryFee,
        acceptsCondo,
        condoFee,
        stopFee,
        acPolicy,
        customPricePerKm,
        bankAccountType,
        bankCode,
        bankAgency,
        bankAccount,
        pixKey,
        pixKeyType,
        totalTrips,
        averageRating,
        createdAt,
        updatedAt,
        currentLocation,
      ]),
    );
  }

  @override
  String toString() => 'BackupDriversMigration(id: $id)';
}
