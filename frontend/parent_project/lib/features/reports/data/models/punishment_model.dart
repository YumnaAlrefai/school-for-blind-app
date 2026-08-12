class PunishmentModel {
  final String name;
  final int level;
  final String description;

  PunishmentModel({
    required this.name,
    required this.level,
    required this.description,
  });

  factory PunishmentModel.fromJson(Map<String, dynamic> json) {
    return PunishmentModel(
      name: json["name"] ?? "",
      level: json["level"] ?? 0,
      description: json["description"] ?? "",
    );
  }
}