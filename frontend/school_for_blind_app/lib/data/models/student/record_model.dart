import 'package:freezed_annotation/freezed_annotation.dart';

part 'record_model.g.dart';

@JsonSerializable()
class LessonRecordsResponse {
  @JsonKey(name: 'lesson_id')
  final String lessonId;
  final List<RecordModel> record;

  LessonRecordsResponse({required this.lessonId, required this.record});

  factory LessonRecordsResponse.fromJson(Map<String, dynamic> json) =>
      _$LessonRecordsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LessonRecordsResponseToJson(this);
}

@JsonSerializable()
class RecordModel {
  final int id;
  final String name;
  final String url;

  RecordModel({required this.id, required this.name, required this.url});

  factory RecordModel.fromJson(Map<String, dynamic> json) =>
      _$RecordModelFromJson(json);
  Map<String, dynamic> toJson() => _$RecordModelToJson(this);
}
