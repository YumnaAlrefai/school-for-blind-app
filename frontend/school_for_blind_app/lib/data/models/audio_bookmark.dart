import 'package:flutter/material.dart';

class AudioBookmark {
  final Duration position;
  String? title;
  bool isEditing;
  late TextEditingController controller;
  AudioBookmark({required this.position, this.title, this.isEditing = false}) {
    controller = TextEditingController();
  }
}
