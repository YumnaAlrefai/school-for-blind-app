// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleResponse _$ScheduleResponseFromJson(Map<String, dynamic> json) =>
    ScheduleResponse(
      status: json['status'] as String,
      data: const ScheduleDataConverter().fromJson(json['data']),
    );

Map<String, dynamic> _$ScheduleResponseToJson(ScheduleResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': const ScheduleDataConverter().toJson(instance.data),
    };

ScheduleItem _$ScheduleItemFromJson(Map<String, dynamic> json) => ScheduleItem(
  id: (json['id'] as num).toInt(),
  classId: (json['class_id'] as num?)?.toInt(),
  teacherId: (json['teacher_id'] as num?)?.toInt(),
  subjectId: (json['subject_id'] as num?)?.toInt(),
  dayOfWeek: json['day_of_week'] as String,
  periodNumber: (json['period_number'] as num).toInt(),
  startTime: json['start_time'] as String,
  endTime: json['end_time'] as String,
  subject: json['subject'] == null
      ? null
      : ScheduleSubject.fromJson(json['subject'] as Map<String, dynamic>),
  studentClass: json['student_class'] == null
      ? null
      : StudentClass.fromJson(json['student_class'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ScheduleItemToJson(ScheduleItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'class_id': instance.classId,
      'teacher_id': instance.teacherId,
      'subject_id': instance.subjectId,
      'day_of_week': instance.dayOfWeek,
      'period_number': instance.periodNumber,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'subject': instance.subject?.toJson(),
      'student_class': instance.studentClass?.toJson(),
    };

ScheduleSubject _$ScheduleSubjectFromJson(Map<String, dynamic> json) =>
    ScheduleSubject(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      gradeLevel: json['grade_level'] as String?,
      numberOfLessons: (json['number_of_lessons'] as num?)?.toInt(),
      totalLessons: (json['total_lessons'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ScheduleSubjectToJson(ScheduleSubject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'grade_level': instance.gradeLevel,
      'number_of_lessons': instance.numberOfLessons,
      'total_lessons': instance.totalLessons,
    };

StudentClass _$StudentClassFromJson(Map<String, dynamic> json) => StudentClass(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  level: json['level'] as String?,
  number: (json['number'] as num?)?.toInt(),
);

Map<String, dynamic> _$StudentClassToJson(StudentClass instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'level': instance.level,
      'number': instance.number,
    };
