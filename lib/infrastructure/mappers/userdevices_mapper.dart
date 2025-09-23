// lib/infrastructure/mappers/userdevices_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/userdevices.dart';
import '../../backend/supabase/database/tables/user_devices.dart';


class UserDevicesMapper {
  UserDevices toDomain(UserDevicesRow row) {
    return UserDevices(
      id: row.id,
      userId: row.userId,
      deviceToken: row.deviceToken,
      platform: row.platform,
      deviceModel: row.deviceModel,
      appVersion: row.appVersion,
      osVersion: row.osVersion,
      isActive: row.isActive,
      lastUsedAt: row.lastUsedAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
  
  Map<String, dynamic> toSupabase(UserDevices entity) {
    return {
      'id': entity.id,
      'user_id': entity.userId,
      'device_token': entity.deviceToken,
      'platform': entity.platform,
      'device_model': entity.deviceModel,
      'app_version': entity.appVersion,
      'os_version': entity.osVersion,
      'is_active': entity.isActive,
      'last_used_at': entity.lastUsedAt,
      'created_at': entity.createdAt,
      'updated_at': entity.updatedAt,
    };
  }

}
