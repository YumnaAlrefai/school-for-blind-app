import 'package:json_annotation/json_annotation.dart';

part 'solved_quiz.g.dart';

@JsonSerializable()
class SolvedQuizzesResponse {
  final String status;
  final int count;
  final List<SolvedQuiz> data;

  SolvedQuizzesResponse({
    required this.status,
    required this.count,
    required this.data,
  });

  factory SolvedQuizzesResponse.fromJson(Map<String, dynamic> json) =>
      _$SolvedQuizzesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SolvedQuizzesResponseToJson(this);
}

@JsonSerializable()
class SolvedQuiz {
  @JsonKey(name: 'submission_id')
  final int submissionId;
  @JsonKey(name: 'quiz_id')
  final int quizId;
  @JsonKey(name: 'quiz_title')
  final String quizTitle;
  @JsonKey(name: 'subject_id')
  final int subjectId;
  @JsonKey(name: 'lesson_id')
  final int lessonId;
  @JsonKey(name: 'total_score')
  final num totalScore;
  @JsonKey(name: 'quiz_max_mark')
  final num quizMaxMark;
  final String status;
  @JsonKey(name: 'submitted_at')
  final String submittedAt;
  @JsonKey(name: 'is_favorited')
  final bool isFavorited;

  SolvedQuiz({
    required this.submissionId,
    required this.quizId,
    required this.quizTitle,
    required this.subjectId,
    required this.lessonId,
    required this.totalScore,
    required this.quizMaxMark,
    required this.status,
    required this.submittedAt,
    required this.isFavorited,
  });

  factory SolvedQuiz.fromJson(Map<String, dynamic> json) =>
      _$SolvedQuizFromJson(json);
  Map<String, dynamic> toJson() => _$SolvedQuizToJson(this);
}
