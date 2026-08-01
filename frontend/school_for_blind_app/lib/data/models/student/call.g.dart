// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Call _$CallFromJson(Map<String, dynamic> json) => Call(
  roomName: json['room_name'] as String,
  startedAt: json['started_at'] as String,
);

Map<String, dynamic> _$CallToJson(Call instance) => <String, dynamic>{
  'room_name': instance.roomName,
  'started_at': instance.startedAt,
};
