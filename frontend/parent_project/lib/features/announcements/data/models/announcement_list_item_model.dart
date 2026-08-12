class AnnouncementListItemModel {
  final int id;
  final String type; // normal | exam_schedule | school_timetable
  final String? content;
  final String createdAt;

  AnnouncementListItemModel({
    required this.id,
    required this.type,
    required this.content,
    required this.createdAt,
  });

  factory AnnouncementListItemModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementListItemModel(
      id: json["id"] ?? 0,
      type: json["type"] ?? "normal",
      content: json["content"],
      createdAt: json["created_at"] ?? "",
    );
  }
}