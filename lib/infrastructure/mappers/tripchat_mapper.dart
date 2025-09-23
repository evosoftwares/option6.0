// lib/infrastructure/mappers/tripchat_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/tripchat.dart';
import '../../backend/supabase/database/tables/trip_chats.dart';


class TripChatMapper {
  TripChat toDomain(TripChatsRow row) {
    return TripChat(
      id: row.id,
      tripId: row.tripId,
      senderId: row.senderId,
      message: row.message,
      isRead: row.isRead,
      readAt: row.readAt,
      createdAt: row.createdAt,
    );
  }
  
  Map<String, dynamic> toSupabase(TripChat entity) {
    return {
      'id': entity.id,
      'trip_id': entity.tripId,
      'sender_id': entity.senderId,
      'message': entity.message,
      'is_read': entity.isRead,
      'read_at': entity.readAt,
      'created_at': entity.createdAt,
    };
  }

}
