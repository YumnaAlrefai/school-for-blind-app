import 'package:json_annotation/json_annotation.dart';

part 'past_exam.g.dart';

@JsonSerializable()
class PastExamsResponse {
  final String status;
  final List<PastExam> data;

  PastExamsResponse({required this.status, required this.data});

  factory PastExamsResponse.fromJson(Map<String, dynamic> json) =>
      _$PastExamsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PastExamsResponseToJson(this);
}

@JsonSerializable()
class PastExam {
  final int id;
  final String title;
  final String year;
  final String session;
  @JsonKey(name: 'is_favorited')
  final bool isSaved;

  PastExam({
    required this.id,
    required this.title,
    required this.year,
    required this.session,
    required this.isSaved,
  });

  factory PastExam.fromJson(Map<String, dynamic> json) =>
      _$PastExamFromJson(json);
  Map<String, dynamic> toJson() => _$PastExamToJson(this);
}
