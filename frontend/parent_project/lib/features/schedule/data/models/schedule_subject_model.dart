class ScheduleSubjectModel {
  final int id;
  final String name;

  ScheduleSubjectModel({required this.id, required this.name});

  factory ScheduleSubjectModel.fromJson(Map<String, dynamic> json) {
    return ScheduleSubjectModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
    );
  }
}