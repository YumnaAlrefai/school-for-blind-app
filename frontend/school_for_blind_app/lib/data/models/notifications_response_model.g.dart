// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsResponse _$NotificationsResponseFromJson(
  Map<String, dynamic> json,
) => NotificationsResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: NotificationData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NotificationsResponseToJson(
  NotificationsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data.toJson(),
};

NotificationData _$NotificationDataFromJson(Map<String, dynamic> json) =>
    NotificationData(
      unreadCount: (json['unread_count'] as num).toInt(),
      totalCount: (json['total_count'] as num).toInt(),
      notifications: (json['notifications'] as List<dynamic>)
          .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NotificationDataToJson(NotificationData instance) =>
    <String, dynamic>{
      'unread_count': instance.unreadCount,
      'total_count': instance.totalCount,
      'notifications': instance.notifications.map((e) => e.toJson()).toList(),
    };

NotificationItem _$NotificationItemFromJson(Map<String, dynamic> json) =>
    NotificationItem(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      body: json['body'] as String,
      data: json['data'] == null
          ? null
          : NotificationPayload.fromJson(json['data'] as Map<String, dynamic>),
      isRead: json['is_read'] as bool,
      readAt: json['read_at'] as String?,
      createdAt: json['created_at'] as String,
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$NotificationItemToJson(NotificationItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'data': instance.data?.toJson(),
      'is_read': instance.isRead,
      'read_at': instance.readAt,
      'created_at': instance.createdAt,
      'timestamp': instance.timestamp,
    };

NotificationPayload _$NotificationPayloadFromJson(Map<String, dynamic> json) =>
    NotificationPayload(
      type: json['type'] as String?,
      screen: json['screen'] as String?,
      announcementId: json['announcement_id'] as String?,
      targetAudience: json['target_audience'] as String?,
    );

Map<String, dynamic> _$NotificationPayloadToJson(
  NotificationPayload instance,
) => <String, dynamic>{
  'type': instance.type,
  'screen': instance.screen,
  'announcement_id': instance.announcementId,
  'target_audience': instance.targetAudience,
};
