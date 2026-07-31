import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessagesResponse {
  final bool success;
  final List<MessageModel> data;
  @JsonKey(name: 'isBanned')
  final bool isBanned;

  MessagesResponse({
    required this.success,
    required this.data,
    this.isBanned = false,
  });

  factory MessagesResponse.fromJson(Map<String, dynamic> json) =>
      _$MessagesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MessagesResponseToJson(this);
}

@JsonSerializable()
class MessageModel {
  final int id;
  @JsonKey(name: 'conversation_id')
  final int? conversationId;
  @JsonKey(name: 'sender_type')
  final String? senderType;
  @JsonKey(name: 'sender_id')
  final int? senderId;
  final String? body;
  @JsonKey(name: 'attachment_path')
  final String? attachmentPath;
  @JsonKey(name: 'attachment_type')
  final String? attachmentType;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final SenderModel? sender;

  MessageModel({
    required this.id,
    this.conversationId,
    this.senderType,
    this.senderId,
    this.body,
    this.attachmentPath,
    this.attachmentType,
    this.createdAt,
    this.updatedAt,
    this.sender,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  String? get fullAttachmentUrl {
    if (attachmentPath == null) return null;
    if (attachmentPath!.startsWith('http')) return attachmentPath;
    return 'https://stays-ability-accustom.ngrok-free.dev/$attachmentPath';
  }
}

@JsonSerializable()
class SenderModel {
  final int id;
  final String? fullname;
  final String? fathersname;
  final String? phone;
  @JsonKey(name: 'parent_phone')
  final String? parentPhone;
  @JsonKey(name: 'class_id')
  final int? classId;
  final int? points;
  final String? level;
  final String? status;

  SenderModel({
    required this.id,
    this.fullname,
    this.fathersname,
    this.phone,
    this.parentPhone,
    this.classId,
    this.points,
    this.level,
    this.status,
  });

  factory SenderModel.fromJson(Map<String, dynamic> json) =>
      _$SenderModelFromJson(json);

  Map<String, dynamic> toJson() => _$SenderModelToJson(this);
}

@JsonSerializable()
class SendMessageResponse {
  final bool success;
  final MessageModel data;

  SendMessageResponse({required this.success, required this.data});

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageResponseToJson(this);
}
