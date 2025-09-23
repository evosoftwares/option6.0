import '/backend/supabase/supabase.dart';
// lib/infrastructure/mappers/appuser_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/appuser.dart';
import '../../backend/supabase/database/tables/app_users.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/phone_number.dart';

class AppUserMapper {
  AppUser toDomain(AppUsersRow row) {
    return AppUser(
      id: row.id,
      email: Email(row.email),
      fullName: row.fullName,
      phone: PhoneNumber(row.phone),
      photoUrl: row.photoUrl,
      userType: row.userType,
      status: row.status,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      fcmToken: row.fcmToken,
      deviceId: row.deviceId,
      devicePlatform: row.devicePlatform,
      lastActiveAt: row.lastActiveAt,
      profileComplete: row.profileComplete,
      onesignalPlayerId: row.onesignalPlayerId,
      idText: row.idText,
    );
  }
  
  Map<String, dynamic> toSupabase(AppUser entity) {
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
