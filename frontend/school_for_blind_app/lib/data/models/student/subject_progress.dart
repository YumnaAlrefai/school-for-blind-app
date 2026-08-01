import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject_progress.g.dart';

@JsonSerializable()
class SubjectProgress {
  @JsonKey(name: 'subject_id')
  String subjectId;
  @JsonKey(name: 'current_lessons')
  int currentLessons;
  @JsonKey(name: 'total_lessons')
  int totalLessons;
  @JsonKey(name: 'progress_text')
  String progressText;

  SubjectProgress({
    required this.subjectId,
    required this.currentLessons,
    required this.totalLessons,
    required this.progressText,
  });
  factory SubjectProgress.fromJson(Map<String, dynamic> json) =>
      _$SubjectProgressFromJson(json);
  Map<String, dynamic> toJson() => _$SubjectProgressToJson(this);
}
