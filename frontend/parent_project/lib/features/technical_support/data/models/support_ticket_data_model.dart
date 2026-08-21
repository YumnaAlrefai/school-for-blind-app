class SupportTicketDataModel {
  final int senderId;
  final String senderType;
  final String message;
  final String? attachmentPath;
  final String updatedAt;
  final String createdAt;
  final int id;

  SupportTicketDataModel({
    required this.senderId,
    required this.senderType,
    required this.message,
    required this.attachmentPath,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory SupportTicketDataModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketDataModel(
      senderId: json["sender_id"] ?? 0,
      senderType: json["sender_type"] ?? "",
      message: json["message"] ?? "",
      attachmentPath: json["attachment_path"],
      updatedAt: json["updated_at"] ?? "",
      createdAt: json["created_at"] ?? "",
      id: json["id"] ?? 0,
    );
  }
}