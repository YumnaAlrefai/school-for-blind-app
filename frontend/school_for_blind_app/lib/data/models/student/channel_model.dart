import 'package:json_annotation/json_annotation.dart';

part 'channel_model.g.dart';

@JsonSerializable()
class ChannelsResponse {
  final bool success;
  final List<ChannelModel> data;

  ChannelsResponse({required this.success, required this.data});

  factory ChannelsResponse.fromJson(Map<String, dynamic> json) =>
      _$ChannelsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelsResponseToJson(this);
}

@JsonSerializable()
class ChannelModel {
  final int id;
  final String type;
  final String name;
  @JsonKey(name: 'teacher_id')
  final int? teacherId;
  @JsonKey(name: 'subject_id')
  final int? subjectId;
  @JsonKey(name: 'parent_id')
  final int? parentId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final DiscussionModel? discussion;
  final TeacherModel? teacher;
  final SubjectModel? subject;

  ChannelModel({
    required this.id,
    required this.type,
    required this.name,
    this.teacherId,
    this.subjectId,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.discussion,
    this.teacher,
    this.subject,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) =>
      _$ChannelModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelModelToJson(this);
}

@JsonSerializable()
class DiscussionModel {
  final int id;
  final String type;
  final String name;
  @JsonKey(name: 'teacher_id')
  final int? teacherId;
  @JsonKey(name: 'subject_id')
  final int? subjectId;
  @JsonKey(name: 'parent_id')
  final int? parentId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  DiscussionModel({
    required this.id,
    required this.type,
    required this.name,
    this.teacherId,
    this.subjectId,
    this.parentId,
    this.createdAt,
    this.updatedAt,
  });

  factory DiscussionModel.fromJson(Map<String, dynamic> json) =>
      _$DiscussionModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiscussionModelToJson(this);
}

@JsonSerializable()
class TeacherModel {
  final int id;
  @JsonKey(name: 'full_name')
  final String? fullName;
  final String? phone;
  final String? subjects;
  final String? level;
  final String? status;

  TeacherModel({
    required this.id,
    this.fullName,
    this.phone,
    this.subjects,
    this.level,
    this.status,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherModelToJson(this);
}

@JsonSerializable()
class SubjectModel {
  final int id;
  final String name;
  @JsonKey(name: 'grade_level')
  final String? gradeLevel;
  @JsonKey(name: 'total_lessons')
  final int? totalLessons;

  SubjectModel({
    required this.id,
    required this.name,
    this.gradeLevel,
    this.totalLessons,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) =>
      _$SubjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectModelToJson(this);
}
