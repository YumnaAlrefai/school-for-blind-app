import 'package:freezed_annotation/freezed_annotation.dart';

part 'saved_lesson.g.dart';

@JsonSerializable()
class SavedLesson {
  final int id;
  final String title;
  @JsonKey(name: 'subject_id')
  final int subjectId;
  @JsonKey(name: 'teacher_id')
  final int teacherId;
  @JsonKey(name: 'class_id')
  final int classId;
  @JsonKey(name: 'has_quiz')
  final bool hasQuiz;

  SavedLesson({
    required this.id,
    required this.title,
    required this.subjectId,
    required this.teacherId,
    required this.classId,
    required this.hasQuiz,
  });

  factory SavedLesson.fromJson(Map<String, dynamic> json) =>
      _$SavedLessonFromJson(json);
  Map<String, dynamic> toJson() => _$SavedLessonToJson(this);
}
