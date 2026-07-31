import 'package:flutter/material.dart';

class AudioBookmark {
  final Duration position;
  String? title;
  bool isEditing;
  final int? serverId;
  late TextEditingController controller;

  AudioBookmark({
    required this.position,
    this.title,
    this.isEditing = false,
    this.serverId,
  }) {
    controller = TextEditingController(text: title ?? '');
  }

  AudioBookmark copyWith({
    Duration? position,
    String? title,
    bool clearTitle = false,
    bool? isEditing,
    int? serverId,
  }) {
    return AudioBookmark(
      position: position ?? this.position,
      title: clearTitle ? null : (title ?? this.title),
      isEditing: isEditing ?? this.isEditing,
      serverId: serverId ?? this.serverId,
    );
  }

  factory AudioBookmark.fromJson(Map<String, dynamic> json) {
    return AudioBookmark(
      position: Duration(seconds: json['position_seconds'] as int),
      title: json['title'] as String?,
      isEditing: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'position_seconds': position.inSeconds, 'title': title};
  }

  factory AudioBookmark.fromApiJson(Map<String, dynamic> json) {
    final rawTimestamp = json['timestamp_in_seconds'];
    final seconds = rawTimestamp is String
        ? int.parse(rawTimestamp)
        : rawTimestamp as int;
    return AudioBookmark(
      position: Duration(seconds: seconds),
      title: json['name'] as String?,
      isEditing: false,
      serverId: json['id'] as int?,
    );
  }
}
