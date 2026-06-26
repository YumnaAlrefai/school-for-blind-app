import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement.g.dart';

@JsonSerializable()
class Announcement {
  final int id;
  final String type;
  final String content;
  Announcement({
    required this.id,
    required this.type,
    required this.content,
  });
  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);
  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);
}
