import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson.g.dart';

@JsonSerializable()
class SubjectLessonsResponse {
  @JsonKey(name: 'subject_id')
  final String subjectId;
  final List<Lesson> lessons;

  SubjectLessonsResponse({required this.subjectId, required this.lessons});

  factory SubjectLessonsResponse.fromJson(Map<String, dynamic> json) =>
      _$SubjectLessonsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SubjectLessonsResponseToJson(this);
}

@JsonSerializable()
class Lesson {
  final int id;
  final String title;
  @JsonKey(name: 'teacher_name')
  final String teacherName;
  @JsonKey(name: 'teacher_id')
  final int teacherId;
  @JsonKey(name: 'is_favorited')
  final bool isSaved;
  @JsonKey(name: 'is_quiz_solved')
  final bool isQuizSolved;

  Lesson({
    required this.id,
    required this.title,
    required this.teacherName,
    required this.teacherId,
    required this.isSaved,
    required this.isQuizSolved,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
  Map<String, dynamic> toJson() => _$LessonToJson(this);
}
