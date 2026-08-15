import 'package:json_annotation/json_annotation.dart';

part 'saved_quiz.g.dart';

@JsonSerializable()
class SavedQuiz {
  final int id;
  @JsonKey(name: 'numofquestions')
  final int numOfQuestions;
  @JsonKey(name: 'timelimit')
  final int timeLimit;
  final int totalmark;
  @JsonKey(name: 'subject_id')
  final int subjectId;
  @JsonKey(name: 'lesson_id')
  final int lessonId;
  @JsonKey(name: 'teacher_id')
  final int teacherId;
  @JsonKey(name: 'subject_name')
  final String subjectName;
  @JsonKey(name: 'teacher_name')
  final String teacherName;

  SavedQuiz({
    required this.id,
    required this.numOfQuestions,
    required this.timeLimit,
    required this.totalmark,
    required this.subjectId,
    required this.lessonId,
    required this.teacherId,
    required this.subjectName,
    required this.teacherName,
  });

  String get displayTitle => 'كويز - $subjectName';

  factory SavedQuiz.fromJson(Map<String, dynamic> json) =>
      _$SavedQuizFromJson(json);
  Map<String, dynamic> toJson() => _$SavedQuizToJson(this);
}
