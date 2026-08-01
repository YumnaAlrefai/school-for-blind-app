import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:school_for_blind_app/data/models/student/message_model.dart';
import 'package:school_for_blind_app/presentation/widgets/student/message_attachments.dart';
import 'package:school_for_blind_app/presentation/widgets/student/message_format_utils.dart';
import 'package:school_for_blind_app/presentation/widgets/student/message_options_sheet.dart';

Widget buildMessageBubble({
  required MessageModel message,
  required bool isMe,
  required BuildContext context,
  required AudioPlayer player,
  required String? currentlyPlayingUrl,
  required Duration playbackPosition,
  required Duration playbackDuration,
  required Function(String url) togglePlay,
}) {
  return GestureDetector(
    onLongPress: () {
      showMessageOptions(context: context, isMe: isMe, messageId: message.id!);
    },
    child: Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        decoration: BoxDecoration(
          color: isMe
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: isMe ? Radius.circular(16.r) : Radius.zero,
            bottomRight: isMe ? Radius.zero : Radius.circular(16.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe && message.sender?.fullname != null) ...[
              Text(
                message.sender!.fullname!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 35.sp,
                ),
              ),
              SizedBox(height: 4.h),
            ],
            if (message.attachmentType == 'image' &&
                message.attachmentPath != null) ...[
              buildImageAttachment(message.fullAttachmentUrl!, context),
              SizedBox(height: 6.h),
            ],
            if (message.attachmentType == 'voice' &&
                message.attachmentPath != null) ...[
              buildVoiceCard(
                url: message.fullAttachmentUrl!,
                isMe: isMe,
                context: context,
                player: player,
                currentlyPlayingUrl: currentlyPlayingUrl,
                playbackPosition: playbackPosition,
                playbackDuration: playbackDuration,
                togglePlay: togglePlay,
              ),
              SizedBox(height: 6.h),
            ],
            if (message.body != null && message.body!.isNotEmpty)
              Text(
                message.body!,
                style: TextStyle(
                  color: isMe
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                  fontSize: 38.sp,
                ),
              ),
            if (message.createdAt != null) ...[
              SizedBox(height: 4.h),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  formatTime(message.createdAt!),
                  style: TextStyle(
                    fontSize: 32.sp,
                    color: isMe
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
