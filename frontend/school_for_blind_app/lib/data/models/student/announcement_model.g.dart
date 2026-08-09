// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
  id: (json['id'] as num).toInt(),
  type: json['type'] as String,
  title: json['title'] as String,
  targetAudience: json['target_audience'] as String?,
  level: json['level'] as String?,
  content: json['content'],
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'target_audience': instance.targetAudience,
      'level': instance.level,
      'content': instance.content,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

ExamDetailResponse _$ExamDetailResponseFromJson(Map<String, dynamic> json) =>
    ExamDetailResponse(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      title: json['title'] as String,
      examProgram: json['exam_program'] == null
          ? null
          : ExamProgramData.fromJson(
              json['exam_program'] as Map<String, dynamic>,
            ),
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$ExamDetailResponseToJson(ExamDetailResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'exam_program': instance.examProgram?.toJson(),
      'created_at': instance.createdAt,
    };

ExamProgramData _$ExamProgramDataFromJson(Map<String, dynamic> json) =>
    ExamProgramData(
      columns: (json['columns'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      rows: (json['rows'] as List<dynamic>)
          .map((e) => ExamRow.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExamProgramDataToJson(ExamProgramData instance) =>
    <String, dynamic>{
      'columns': instance.columns,
      'rows': instance.rows.map((e) => e.toJson()).toList(),
    };

ExamRow _$ExamRowFromJson(Map<String, dynamic> json) => ExamRow(
  date: json['date'] as String,
  subject: json['subject'] as String,
  time: json['time'] as String,
);

Map<String, dynamic> _$ExamRowToJson(ExamRow instance) => <String, dynamic>{
  'date': instance.date,
  'subject': instance.subject,
  'time': instance.time,
};
