import '/backend/supabase/supabase.dart';
// lib/infrastructure/mappers/appusers_mapper.dart
import '../../domain/entities/appusers.dart';
import '../../backend/supabase/database/tables/app_users.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/phone_number.dart';

class AppUsersMapper {
  AppUsers toDomain(AppUsersRow row) {
    return AppUsers(
      id: row.id,
      email: Email(row.email ?? 'placeholder@example.com'),
      fullName: row.fullName ?? '',
      phone: PhoneNumber(row.phone ?? '+1234567890'),
      photoUrl: row.photoUrl ?? '',
      userType: row.userType ?? '',
      status: row.status ?? '',
      createdAt: row.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: row.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      fcmToken: row.fcmToken ?? '',
      deviceId: row.deviceId ?? '',
      devicePlatform: row.devicePlatform ?? '',
      lastActiveAt: row.lastActiveAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      profileComplete: row.profileComplete ?? false,
      onesignalPlayerId: row.onesignalPlayerId,
      idText: row.id, // Use id field as idText since idText doesn't exist in AppUsersRow
    );
  }
  
  Map<String, dynamic> toSupabase(AppUsers entity) {
    return {
      'id': entity.id,
      'email': entity.email.value,
      'full_name': entity.fullName,
      'phone': entity.phone.value,
      'photo_url': entity.photoUrl,
      'user_type': entity.userType,
      'status': entity.status,
      'created_at': entity.createdAt,
      'updated_at': entity.updatedAt,
      'fcm_token': entity.fcmToken,
      'device_id': entity.deviceId,
      'device_platform': entity.devicePlatform,
      'last_active_at': entity.lastActiveAt,
      'profile_complete': entity.profileComplete,
      'onesignal_player_id': entity.onesignalPlayerId,
      'id_text': entity.idText,
    };
  }
}
