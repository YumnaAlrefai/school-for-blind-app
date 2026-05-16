// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacherModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeacherModel _$TeacherModelFromJson(Map<String, dynamic> json) => TeacherModel(
  id: (json['id'] as num?)?.toInt(),
  fullName: json['full_name'] as String?,
  phone: json['phone'] as String?,
  subjects: json['subjects'] as String?,
  level: json['level'] as String?,
  token: json['token'] as String?,
);

Map<String, dynamic> _$TeacherModelToJson(TeacherModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'subjects': instance.subjects,
      'level': instance.level,
      'token': instance.token,
    };
