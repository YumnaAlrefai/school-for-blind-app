// import 'package:json_annotation/json_annotation.dart';
// part 'student_model.g.dart';

// @JsonSerializable()
// class StudentModel {
//   int? id;
//   String? firstname;
//   String? lastname;
//   String? email;
//   String? birthDate;
//   String? phone;
//   String? website;

//   StudentModel({
//     this.id,
//     this.firstname,
//     this.lastname,
//     this.email,
//     this.birthDate,
//     this.phone,
//     this.website,
//   });
//   //على مستوى الكلاس
//   factory StudentModel.fromJson(Map<String, dynamic> json) => _$StudentModelFromJson(json);
//   //على مستوى الكائن
//   Map<String, dynamic> toJson() => _$UserToJson(this);
// }
// class StudentModel {
//   final String fullName;
//   final String fatherName;
//   final String parentPhone;
//   final String level;

//   StudentModel({
//     required this.fullName,
//     required this.fatherName,
//     required this.parentPhone,
//     required this.level,
//   });

//   factory StudentModel.fromJson(Map<String, dynamic> json) {
//     return StudentModel(
//       fullName: json['fullName'],
//       fatherName: json['fatherName'],
//       parentPhone: json['parentPhone'],
//       level: json['level'],
//     );
//   }
// }
