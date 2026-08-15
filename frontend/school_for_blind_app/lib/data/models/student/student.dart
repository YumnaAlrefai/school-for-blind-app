import 'package:json_annotation/json_annotation.dart';

part 'student.g.dart';

@JsonSerializable()
class Student {
  int id;
  @JsonKey(name: 'fullname')
  String fullName;
  @JsonKey(name: 'fathersname')
  String fatherName;
  String phone;
  @JsonKey(name: 'parent_phone')
  String parentPhone;
  String level;
  String status;
  @JsonKey(name: 'DocumentaryEvidence')
  String documentaryEvidence;

  Student({
    required this.id,
    required this.fullName,
    required this.fatherName,
    required this.phone,
    required this.parentPhone,
    required this.level,
    required this.status,
    required this.documentaryEvidence,
  });

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
  Map<String, dynamic> toJson() => _$StudentToJson(this);
}
