import 'package:freezed_annotation/freezed_annotation.dart';

part 'call.g.dart';

@JsonSerializable()
class Call {
  @JsonKey(name: 'room_name')
  String roomName;
  @JsonKey(name: 'started_at')
  String startedAt;

  Call({required this.roomName, required this.startedAt});
  factory Call.fromJson(Map<String, dynamic> json) => _$CallFromJson(json);
  Map<String, dynamic> toJson() => _$CallToJson(this);
}
