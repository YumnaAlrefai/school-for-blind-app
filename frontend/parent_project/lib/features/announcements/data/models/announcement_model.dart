class AnnouncementModel {
  final int id;
  final String type;
  final String? title;
  final String? content;
  final String createdAt;

  AnnouncementModel({
    required this.id,
    required this.type,
    this.title,
    this.content,
    required this.createdAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json["id"] ?? 0,
      type: json["type"] ?? "",
      title: json["title"],
      content: json["content"],
      createdAt: json["created_at"] ?? "",
    );
  }
}