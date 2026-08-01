import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:school_for_blind_app/presentation/widgets/student/message_format_utils.dart';

Widget buildImageAttachment(String url, BuildContext context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(12.r),
    child: Image.network(
      url,
      width: 300.w,
      fit: BoxFit.cover,
      headers: const {'ngrok-skip-browser-warning': 'true'},
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return SizedBox(
          height: 150.h,
          width: 300.w,
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 120.h,
          width: 300.w,
          color: Theme.of(context).colorScheme.surface,
          child: Icon(
            Icons.broken_image,
            color: Theme.of(context).colorScheme.primary,
            size: 50.sp,
          ),
        );
      },
    ),
  );
}

Widget buildVoiceCard({
  required String url,
  required bool isMe,
  required BuildContext context,
  required AudioPlayer player,
  required String? currentlyPlayingUrl,
  required Duration playbackPosition,
  required Duration playbackDuration,
  required Function(String url) togglePlay,
}) {
  final isCurrentAudio = currentlyPlayingUrl == url;

  final textColor = isMe
      ? Theme.of(context).colorScheme.onPrimary
      : Theme.of(context).colorScheme.onSurface;

  final currentPosition = isCurrentAudio ? playbackPosition : Duration.zero;
  final totalDuration = isCurrentAudio ? playbackDuration : Duration.zero;

  return Container(
    width: 300.w,
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
    decoration: BoxDecoration(
      color: isMe
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: textColor.withOpacity(0.5)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(
            (isCurrentAudio && player.state == PlayerState.playing)
                ? Icons.pause_circle_filled_rounded
                : Icons.play_circle_fill_rounded,
            color: textColor,
            size: 57.sp,
          ),
          onPressed: () => togglePlay(url),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 5,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                    disabledThumbRadius: 8,
                  ),
                  overlayShape: SliderComponentShape.noOverlay,
                  activeTrackColor: textColor,
                  inactiveTrackColor: textColor.withOpacity(0.3),
                  disabledActiveTrackColor: textColor,
                  disabledInactiveTrackColor: textColor.withOpacity(0.3),
                  thumbColor: textColor,
                  disabledThumbColor: textColor,
                ),
                child: Slider(
                  min: 0,
                  max: totalDuration.inMilliseconds.toDouble(),
                  value: currentPosition.inMilliseconds
                      .clamp(0, totalDuration.inMilliseconds)
                      .toDouble(),
                  onChanged: isCurrentAudio
                      ? (value) {
                          player.seek(Duration(milliseconds: value.toInt()));
                        }
                      : null,
                ),
              ),
              SizedBox(height: 4.h),
              Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: Text(
                  '${formatDuration(currentPosition)}/${formatDuration(totalDuration)}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
