import 'package:flutter/material.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/teacher_chat_conversation_screen.dart';

/// شاشة قناة بثّ — المعلّم يرسل نصوصاً وصوتيات (نفس واجهة المحادثة).
class TeacherChannelScreen extends StatelessWidget {
  final int channelId;
  final String channelName;
  final IconData? icon;

  const TeacherChannelScreen({
    super.key,
    required this.channelId,
    required this.channelName,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TeacherChatConversationScreen(
      chatId: channelId,
      title: channelName,
      isGroup: true,
      icon: icon,
    );
  }
}