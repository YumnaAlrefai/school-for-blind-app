class PunishmentModel {
  final int id;
  final String name;
  final int level;
  final bool canObject;
  final String description;
  final String? objectionStatus;

  PunishmentModel({
    required this.id,
    required this.name,
    required this.level,
    required this.canObject,
    required this.description,
    required this.objectionStatus,
  });

  factory PunishmentModel.fromJson(Map<String, dynamic> json) {
    return PunishmentModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      level: json["level"] ?? 0,
      canObject: json["can_object"] ?? false,
      description: json["description"] ?? "",
      objectionStatus: json["objection_status"],
    );
  }
}