import '/backend/supabase/supabase.dart';
// lib/infrastructure/mappers/notification_mapper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/notification.dart';
import '../../backend/supabase/database/tables/notifications.dart';


class NotificationMapper {
  Notification toDomain(NotificationsRow row) {
    return Notification(
      id: row.id,
      userId: row.userId,
      title: row.title,
      body: row.body,
      type: row.type,
      dataField: row.dataField,
      priority: row.priority,
      isRead: row.isRead,
      sentAt: row.sentAt,
      readAt: row.readAt,
      createdAt: row.createdAt,
    );
  }
  
  Map<String, dynamic> toSupabase(Notification entity) {
    return {
      'id': entity.id,
      'user_id': entity.userId,
      'title': entity.title,
      'body': entity.body,
      'type': entity.type,
      'data': entity.dataField,
      'priority': entity.priority,
      'is_read': entity.isRead,
      'sent_at': entity.sentAt,
      'read_at': entity.readAt,
      'created_at': entity.createdAt,
    };
  }

}
