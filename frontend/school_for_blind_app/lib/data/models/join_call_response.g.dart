// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_call_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinCallResponse _$JoinCallResponseFromJson(Map<String, dynamic> json) =>
    JoinCallResponse(
      message: json['message'] as String,
      roomName: json['room_name'] as String,
      token: json['token'] as String,
    );

Map<String, dynamic> _$JoinCallResponseToJson(JoinCallResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'room_name': instance.roomName,
      'token': instance.token,
    };
