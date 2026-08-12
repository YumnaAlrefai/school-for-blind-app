class AttendanceModel {
  final int roomId;
  final String roomName;
  final bool canExcuse;
  final bool isAttended;
  final String? excuseStatus;
  final int totalRoomMinutes;
  final int studentPresenceMinutes;

  AttendanceModel({
    required this.roomId,
    required this.roomName,
    required this.canExcuse,
    required this.isAttended,
    required this.excuseStatus,
    required this.totalRoomMinutes,
    required this.studentPresenceMinutes,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      roomId: json["room_id"] ?? 0,
      roomName: json["room_name"] ?? "",
      canExcuse: json["can_excuse"] ?? false,
      isAttended: json["is_attended"] ?? false,
      excuseStatus: json["excuse_status"],
      totalRoomMinutes: json["total_room_minutes"] ?? 0,
      studentPresenceMinutes: json["student_presence_minutes"] ?? 0,
    );
  }
}