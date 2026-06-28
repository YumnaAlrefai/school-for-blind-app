import 'package:json_annotation/json_annotation.dart';

part 'teacherModel.g.dart';
@JsonSerializable()
class TeacherModel {
  int? id;
  @JsonKey(name: 'full_name')
  String? fullName;
  String? phone;
  String? subjects;
  String? level;
  String? token; 
  TeacherModel({this.id, this.fullName, this.phone, this.subjects, this.level, this.token});

  factory TeacherModel.fromJson(Map<String, dynamic> json) => _$TeacherModelFromJson(json);
  Map<String, dynamic> toJson() => _$TeacherModelToJson(this);
}