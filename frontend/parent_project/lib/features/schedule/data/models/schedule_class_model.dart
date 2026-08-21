class ScheduleClassModel {
  final int id;
  final String name;
  final String level;
  final int number;

  ScheduleClassModel({
    required this.id,
    required this.name,
    required this.level,
    required this.number,
  });

  factory ScheduleClassModel.fromJson(Map<String, dynamic> json) {
    return ScheduleClassModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      level: json["level"] ?? "",
      number: json["number"] ?? 0,
    );
  }
}