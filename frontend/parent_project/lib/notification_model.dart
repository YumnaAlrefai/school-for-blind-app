class NotificationModel {
  final int id;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final bool isRead;
  final String? readAt;
  final String createdAt;
  final DateTime timestamp;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.data,
    required this.isRead,
    this.readAt,
    required this.createdAt,
    required this.timestamp,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      data: json['data'] != null
          ? Map<String, dynamic>.from(json['data'])
          : null,
      isRead: json['is_read'] ?? false,
      readAt: json['read_at'],
      createdAt: json['created_at'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class NotificationsResponse {
  final int unreadCount;
  final int totalCount;
  final List<NotificationModel> notifications;

  NotificationsResponse({
    required this.unreadCount,
    required this.totalCount,
    required this.notifications,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return NotificationsResponse(
      unreadCount: data['unread_count'] ?? 0,
      totalCount: data['total_count'] ?? 0,
      notifications: (data['notifications'] as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList(),
    );
  }
}
