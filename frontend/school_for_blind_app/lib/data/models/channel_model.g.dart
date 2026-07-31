// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelsResponse _$ChannelsResponseFromJson(Map<String, dynamic> json) =>
    ChannelsResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => ChannelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChannelsResponseToJson(ChannelsResponse instance) =>
    <String, dynamic>{'success': instance.success, 'data': instance.data};

ChannelModel _$ChannelModelFromJson(Map<String, dynamic> json) => ChannelModel(
  id: (json['id'] as num).toInt(),
  type: json['type'] as String,
  name: json['name'] as String,
  teacherId: (json['teacher_id'] as num?)?.toInt(),
  subjectId: (json['subject_id'] as num?)?.toInt(),
  parentId: (json['parent_id'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  discussion: json['discussion'] == null
      ? null
      : DiscussionModel.fromJson(json['discussion'] as Map<String, dynamic>),
  teacher: json['teacher'] == null
      ? null
      : TeacherModel.fromJson(json['teacher'] as Map<String, dynamic>),
  subject: json['subject'] == null
      ? null
      : SubjectModel.fromJson(json['subject'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChannelModelToJson(ChannelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'teacher_id': instance.teacherId,
      'subject_id': instance.subjectId,
      'parent_id': instance.parentId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'discussion': instance.discussion,
      'teacher': instance.teacher,
      'subject': instance.subject,
    };

DiscussionModel _$DiscussionModelFromJson(Map<String, dynamic> json) =>
    DiscussionModel(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      name: json['name'] as String,
      teacherId: (json['teacher_id'] as num?)?.toInt(),
      subjectId: (json['subject_id'] as num?)?.toInt(),
      parentId: (json['parent_id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$DiscussionModelToJson(DiscussionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'teacher_id': instance.teacherId,
      'subject_id': instance.subjectId,
      'parent_id': instance.parentId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

TeacherModel _$TeacherModelFromJson(Map<String, dynamic> json) => TeacherModel(
  id: (json['id'] as num).toInt(),
  fullName: json['full_name'] as String?,
  phone: json['phone'] as String?,
  subjects: json['subjects'] as String?,
  level: json['level'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$TeacherModelToJson(TeacherModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'subjects': instance.subjects,
      'level': instance.level,
      'status': instance.status,
    };

SubjectModel _$SubjectModelFromJson(Map<String, dynamic> json) => SubjectModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  gradeLevel: json['grade_level'] as String?,
  totalLessons: (json['total_lessons'] as num?)?.toInt(),
);

Map<String, dynamic> _$SubjectModelToJson(SubjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'grade_level': instance.gradeLevel,
      'total_lessons': instance.totalLessons,
    };
