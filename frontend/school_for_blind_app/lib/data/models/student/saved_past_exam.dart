import 'package:json_annotation/json_annotation.dart';

part 'saved_past_exam.g.dart';

@JsonSerializable()
class SavedPastExam {
  final int id;
  final String title;
  final String year;
  final String session;
  @JsonKey(name: 'subject_id')
  final int subjectId;

  SavedPastExam({
    required this.id,
    required this.title,
    required this.year,
    required this.session,
    required this.subjectId,
  });

  factory SavedPastExam.fromJson(Map<String, dynamic> json) =>
      _$SavedPastExamFromJson(json);
  Map<String, dynamic> toJson() => _$SavedPastExamToJson(this);
}
