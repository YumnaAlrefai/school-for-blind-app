import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

Future<void> startRecording({
  required AudioRecorder recorder,
  required Function(
    bool isRecording,
    bool isPaused,
    Duration duration,
    DateTime? startTime,
    Duration pausedElapsed,
  )
  onStateChange,
  required Function(Duration d) tick,
}) async {
  if (!await recorder.hasPermission()) return;

  final dir = await getTemporaryDirectory();
  final path = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

  await recorder.start(const RecordConfig(), path: path);

  onStateChange(true, false, Duration.zero, DateTime.now(), Duration.zero);

  _tick(recorder, tick);
}

void _tick(AudioRecorder recorder, Function(Duration d) tick) async {
  DateTime? startTime = DateTime.now();
  Duration pausedElapsed = Duration.zero;
  bool isPaused = false;

  while (await recorder.isRecording()) {
    await Future.delayed(const Duration(milliseconds: 300));

    if (isPaused || startTime == null) continue;

    tick(pausedElapsed + DateTime.now().difference(startTime));
  }
}

Future<void> togglePauseResume({
  required AudioRecorder recorder,
  required bool isPaused,
  required Duration recordDuration,
  required Function(bool paused, DateTime? start, Duration pausedElapsed)
  onStateChange,
}) async {
  if (isPaused) {
    await recorder.resume();
    onStateChange(false, DateTime.now(), recordDuration);
  } else {
    await recorder.pause();
    onStateChange(true, null, recordDuration);
  }
}

Future<void> stopRecording({
  required AudioRecorder recorder,
  required bool cancel,
  required Function(File file, String type) onAttachment,
  required Function() onStop,
}) async {
  final path = await recorder.stop();
  onStop();

  if (cancel || path == null) return;

  onAttachment(File(path), 'voice');
}

Widget buildRecordingBar({
  required Duration recordDuration,
  required bool isPaused,
  required Function() deleteRecording,
  required Function() togglePauseResume,
  required Function() confirmRecording,
  required BuildContext context,
}) {
  final minutes = recordDuration.inMinutes.toString().padLeft(2, '0');
  final seconds = (recordDuration.inSeconds % 60).toString().padLeft(2, '0');

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 25.h),
    color: Theme.of(context).colorScheme.surface,
    child: SafeArea(
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Color(0xffff3333),
              size: 35.sp,
            ),
            onPressed: deleteRecording,
          ),
          SizedBox(width: 13.w),
          AvatarGlow(
            glowColor: Color(0xffff3333),
            child: Icon(
              isPaused ? Icons.pause : Icons.mic,
              color: Color(0xffff3333),
              size: 35.sp,
            ),
          ),
          SizedBox(width: 29.w),
          Expanded(
            child: Text(
              '$minutes:$seconds',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 32.sp,
              ),
            ),
          ),
          const Spacer(),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: IconButton(
              icon: Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: confirmRecording,
            ),
          ),
        ],
      ),
    ),
  );
}
