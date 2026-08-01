// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessagesResponse _$MessagesResponseFromJson(Map<String, dynamic> json) =>
    MessagesResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isBanned: json['isBanned'] as bool? ?? false,
    );

Map<String, dynamic> _$MessagesResponseToJson(MessagesResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'isBanned': instance.isBanned,
    };

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
  id: (json['id'] as num).toInt(),
  conversationId: (json['conversation_id'] as num?)?.toInt(),
  senderType: json['sender_type'] as String?,
  senderId: (json['sender_id'] as num?)?.toInt(),
  body: json['body'] as String?,
  attachmentPath: json['attachment_path'] as String?,
  attachmentType: json['attachment_type'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  sender: json['sender'] == null
      ? null
      : SenderModel.fromJson(json['sender'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'sender_type': instance.senderType,
      'sender_id': instance.senderId,
      'body': instance.body,
      'attachment_path': instance.attachmentPath,
      'attachment_type': instance.attachmentType,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'sender': instance.sender,
    };

SenderModel _$SenderModelFromJson(Map<String, dynamic> json) => SenderModel(
  id: (json['id'] as num).toInt(),
  fullname: json['fullname'] as String?,
  fathersname: json['fathersname'] as String?,
  phone: json['phone'] as String?,
  parentPhone: json['parent_phone'] as String?,
  classId: (json['class_id'] as num?)?.toInt(),
  points: (json['points'] as num?)?.toInt(),
  level: json['level'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$SenderModelToJson(SenderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'fathersname': instance.fathersname,
      'phone': instance.phone,
      'parent_phone': instance.parentPhone,
      'class_id': instance.classId,
      'points': instance.points,
      'level': instance.level,
      'status': instance.status,
    };

SendMessageResponse _$SendMessageResponseFromJson(Map<String, dynamic> json) =>
    SendMessageResponse(
      success: json['success'] as bool,
      data: MessageModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SendMessageResponseToJson(
  SendMessageResponse instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};
