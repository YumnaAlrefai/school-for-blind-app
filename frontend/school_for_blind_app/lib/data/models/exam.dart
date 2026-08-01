import 'package:json_annotation/json_annotation.dart';

part 'exam.g.dart';

@JsonSerializable()
class ExamsResponse {
  final String status;
  final List<Exam> data;

  ExamsResponse({required this.status, required this.data});

  factory ExamsResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExamsResponseToJson(this);
}

@JsonSerializable()
class Exam {
  final int id;
  @JsonKey(name: 'teacher_id')
  final int teacherId;
  final String title;
  final String? description;
  @JsonKey(name: 'subject_id')
  final int subjectId;
  @JsonKey(name: 'exam_date')
  final DateTime? examDate;
  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;
  @JsonKey(name: 'numofquestions')
  final int numOfQuestions;
  final int totalmark;
  @JsonKey(name: 'is_published')
  final int isPublished;
  @JsonKey(name: 'is_favorited')
  final bool isFavorited;

  Exam({
    required this.id,
    required this.teacherId,
    required this.title,
    this.description,
    required this.subjectId,
    this.examDate,
    required this.durationMinutes,
    required this.numOfQuestions,
    required this.totalmark,
    required this.isPublished,
    required this.isFavorited,
  });

  factory Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);
  Map<String, dynamic> toJson() => _$ExamToJson(this);
}
