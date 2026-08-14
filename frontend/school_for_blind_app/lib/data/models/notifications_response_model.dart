import 'package:json_annotation/json_annotation.dart';

part 'notifications_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NotificationsResponse {
  final bool success;
  final String message;
  final NotificationData data;

  NotificationsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NotificationData {
  @JsonKey(name: 'unread_count')
  final int unreadCount;
  @JsonKey(name: 'total_count')
  final int totalCount;
  final List<NotificationItem> notifications;

  NotificationData({
    required this.unreadCount,
    required this.totalCount,
    required this.notifications,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NotificationItem {
  final int id;
  final String title;
  final String body;
  final NotificationPayload? data;
  @JsonKey(name: 'is_read')
  final bool isRead;
  @JsonKey(name: 'read_at')
  final String? readAt;
  @JsonKey(name: 'created_at')
  final String createdAt;
  final String timestamp;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    this.data,
    required this.isRead,
    this.readAt,
    required this.createdAt,
    required this.timestamp,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationItemToJson(this);
}

@JsonSerializable()
class NotificationPayload {
  final String? type;
  final String? screen;
  @JsonKey(name: 'announcement_id')
  final String? announcementId;
  @JsonKey(name: 'target_audience')
  final String? targetAudience;

  NotificationPayload({
    this.type,
    this.screen,
    this.announcementId,
    this.targetAudience,
  });

  factory NotificationPayload.fromJson(Map<String, dynamic> json) =>
      _$NotificationPayloadFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationPayloadToJson(this);
}
