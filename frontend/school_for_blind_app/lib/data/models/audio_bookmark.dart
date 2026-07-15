import 'package:flutter/material.dart';

class AudioBookmark {
  final Duration position;
  String? title;
  bool isEditing;
  late TextEditingController controller;

  AudioBookmark({required this.position, this.title, this.isEditing = false}) {
    controller = TextEditingController(text: title ?? '');
  }

  AudioBookmark copyWith({
    Duration? position,
    String? title,
    bool clearTitle = false,
    bool? isEditing,
  }) {
    return AudioBookmark(
      position: position ?? this.position,
      title: clearTitle ? null : (title ?? this.title),
      isEditing: isEditing ?? this.isEditing,
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
}
