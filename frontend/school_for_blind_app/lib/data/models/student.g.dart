// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
  id: (json['id'] as num).toInt(),
  fullName: json['fullname'] as String,
  fatherName: json['fathersname'] as String,
  phone: json['phone'] as String,
  parentPhone: json['parent_phone'] as String,
  level: json['level'] as String,
  status: json['status'] as String,
  documentaryEvidence: json['DocumentaryEvidence'] as String,
);

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
  'id': instance.id,
  'fullname': instance.fullName,
  'fathersname': instance.fatherName,
  'phone': instance.phone,
  'parent_phone': instance.parentPhone,
  'level': instance.level,
  'status': instance.status,
  'DocumentaryEvidence': instance.documentaryEvidence,
};
