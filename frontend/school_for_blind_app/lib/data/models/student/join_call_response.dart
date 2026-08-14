import 'package:json_annotation/json_annotation.dart';

part 'join_call_response.g.dart';

@JsonSerializable()
class JoinCallResponse {
  final String message;
  @JsonKey(name: 'room_name')
  final String roomName;
  final String token;

  JoinCallResponse({
    required this.message,
    required this.roomName,
    required this.token,
  });

  factory JoinCallResponse.fromJson(Map<String, dynamic> json) =>
      _$JoinCallResponseFromJson(json);
  Map<String, dynamic> toJson() => _$JoinCallResponseToJson(this);
}
