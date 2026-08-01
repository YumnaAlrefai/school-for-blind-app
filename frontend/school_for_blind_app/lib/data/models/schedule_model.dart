import 'package:json_annotation/json_annotation.dart';

part 'schedule_model.g.dart';

class ScheduleDataConverter
    implements JsonConverter<Map<String, List<ScheduleItem>>, dynamic> {
  const ScheduleDataConverter();

  @override
  Map<String, List<ScheduleItem>> fromJson(dynamic json) {
    if (json is List) {
      return {};
    }
    if (json is Map<String, dynamic>) {
      return json.map((key, value) {
        final list = (value as List<dynamic>)
            .map((e) => ScheduleItem.fromJson(e as Map<String, dynamic>))
            .toList();
        return MapEntry(key, list);
      });
    }

    return {};
  }

  @override
  dynamic toJson(Map<String, List<ScheduleItem>> object) {
    return object.map(
      (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ScheduleResponse {
  final String status;

  @ScheduleDataConverter()
  final Map<String, List<ScheduleItem>> data;

  ScheduleResponse({required this.status, required this.data});

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ScheduleItem {
  final int id;
  @JsonKey(name: 'class_id')
  final int? classId;
  @JsonKey(name: 'teacher_id')
  final int? teacherId;
  @JsonKey(name: 'subject_id')
  final int? subjectId;
  @JsonKey(name: 'day_of_week')
  final String dayOfWeek;
  @JsonKey(name: 'period_number')
  final int periodNumber;
  @JsonKey(name: 'start_time')
  final String startTime;
  @JsonKey(name: 'end_time')
  final String endTime;

  final ScheduleSubject? subject;
  @JsonKey(name: 'student_class')
  final StudentClass? studentClass;

  ScheduleItem({
    required this.id,
    this.classId,
    this.teacherId,
    this.subjectId,
    required this.dayOfWeek,
    required this.periodNumber,
    required this.startTime,
    required this.endTime,
    this.subject,
    this.studentClass,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) =>
      _$ScheduleItemFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleItemToJson(this);
}

@JsonSerializable()
class ScheduleSubject {
  final int id;
  final String name;
  @JsonKey(name: 'grade_level')
  final String? gradeLevel;
  @JsonKey(name: 'number_of_lessons')
  final int? numberOfLessons;
  @JsonKey(name: 'total_lessons')
  final int? totalLessons;

  ScheduleSubject({
    required this.id,
    required this.name,
    this.gradeLevel,
    this.numberOfLessons,
    this.totalLessons,
  });

  factory ScheduleSubject.fromJson(Map<String, dynamic> json) =>
      _$ScheduleSubjectFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleSubjectToJson(this);
}

@JsonSerializable()
class StudentClass {
  final int id;
  final String name;
  final String? level;
  final int? number;

  StudentClass({required this.id, required this.name, this.level, this.number});

  factory StudentClass.fromJson(Map<String, dynamic> json) =>
      _$StudentClassFromJson(json);

  Map<String, dynamic> toJson() => _$StudentClassToJson(this);
}
