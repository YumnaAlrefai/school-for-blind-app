import 'package:json_annotation/json_annotation.dart';

part 'announcement_model.g.dart';

@JsonSerializable()
class Announcement {
  final int id;
  final String type;
  final String title;
  @JsonKey(name: 'target_audience')
  final String? targetAudience;
  final String? level;
  final dynamic content;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Announcement({
    required this.id,
    required this.type,
    required this.title,
    this.targetAudience,
    this.level,
    required this.content,
    required this.createdAt,
    this.updatedAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);
  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);

  String get contentAsString {
    if (content is String) {
      return content as String;
    } else if (content is Map) {
      return 'برنامج تفصيلي (انقر للإطلاع)';
    }
    return content.toString();
  }
}

@JsonSerializable(explicitToJson: true)
class ExamDetailResponse {
  final int id;
  final String type;
  final String title;
  @JsonKey(name: 'exam_program')
  final ExamProgramData? examProgram;
  @JsonKey(name: 'created_at')
  final String createdAt;

  ExamDetailResponse({
    required this.id,
    required this.type,
    required this.title,
    this.examProgram,
    required this.createdAt,
  });

  factory ExamDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamDetailResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExamDetailResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ExamProgramData {
  final List<String> columns;
  final List<ExamRow> rows;

  ExamProgramData({required this.columns, required this.rows});

  factory ExamProgramData.fromJson(Map<String, dynamic> json) =>
      _$ExamProgramDataFromJson(json);
  Map<String, dynamic> toJson() => _$ExamProgramDataToJson(this);
}

@JsonSerializable()
class ExamRow {
  final String date;
  final String subject;
  final String time;

  ExamRow({required this.date, required this.subject, required this.time});

  factory ExamRow.fromJson(Map<String, dynamic> json) =>
      _$ExamRowFromJson(json);
  Map<String, dynamic> toJson() => _$ExamRowToJson(this);
}
