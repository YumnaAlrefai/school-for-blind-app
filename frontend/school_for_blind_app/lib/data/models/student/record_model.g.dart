// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonRecordsResponse _$LessonRecordsResponseFromJson(
  Map<String, dynamic> json,
) => LessonRecordsResponse(
  lessonId: json['lesson_id'] as String,
  record: (json['record'] as List<dynamic>)
      .map((e) => RecordModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LessonRecordsResponseToJson(
  LessonRecordsResponse instance,
) => <String, dynamic>{
  'lesson_id': instance.lessonId,
  'record': instance.record,
};

RecordModel _$RecordModelFromJson(Map<String, dynamic> json) => RecordModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  url: json['url'] as String,
);

Map<String, dynamic> _$RecordModelToJson(RecordModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
    };
