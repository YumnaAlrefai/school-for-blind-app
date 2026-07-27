import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:school_for_blind_app/apiTeacher/lesson_audio_service.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_home_screen.dart';





class LessonAudioCard extends StatelessWidget {
  final Lesson lesson;
  final bool isExpanded;
  final LessonAudioService audioService;
  final double speed;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onCreateQuiz;
  final VoidCallback onSpeedTap;

  const LessonAudioCard({
    super.key,
    required this.lesson,
    required this.isExpanded,
    required this.audioService,
    required this.speed,
    required this.onTap,
    required this.onDelete,
    required this.onCreateQuiz,
    required this.onSpeedTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 354,
        height: isExpanded ? 160 : 75,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.50), width: 0.5),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            if (isExpanded) _buildPlayer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        
        if (isExpanded)
          _buildPlayPauseButton()
        else
          const Icon(Icons.play_circle_outline, size: 33, color: Colors.white),

        
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              lesson.title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 24),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        
        GestureDetector(
          onTap: () => _showOptionsSheet(context),
          child: const Icon(
            Icons.more_vert,
            size: 28,
            color: AppColors.kPrimaryColor,
          ),
        ),
      ],
    );
  }

  
  void _showOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.kBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => Directionality(
        textDirection: TextDirection.ltr,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              
              if (!lesson.hasQuiz)
                ListTile(
                  leading: const Icon(
                    Icons.quiz_outlined,
                    color: AppColors.kPrimaryColor,
                  ),
                  title: const Text(
                    'إنشاء كويز',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  onTap: () {
                    Navigator.pop(sheetCtx);
                    onCreateQuiz();
                  },
                ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: AppColors.kPrimaryColor,
                ),
                title: const Text(
                  'حذف الدرس',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  onDelete();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return StreamBuilder<PlayerState>(
      stream: audioService.playerStateStream,
      builder: (context, snapshot) {
        final playing = snapshot.data?.playing ?? false;
        return GestureDetector(
          onTap: audioService.toggle,
          child: Icon(
            playing ? Icons.pause_circle_outline : Icons.play_circle_outline,
            size: 33,
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildPlayer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: StreamBuilder<Duration>(
        stream: audioService.positionStream,
        builder: (context, snapshot) {
          final position = snapshot.data ?? Duration.zero;
          final total = audioService.totalDuration ?? Duration.zero;

          return Column(
            children: [
              _buildTimeRow(position, total),
              _buildSliderRow(context, position, total),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimeRow(Duration position, Duration total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          LessonAudioService.formatTime(position),
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        Text(
          total == Duration.zero
              ? lesson.duration
              : LessonAudioService.formatTime(total),
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSliderRow(
    BuildContext context,
    Duration position,
    Duration total,
  ) {
    return Row(
      textDirection: TextDirection.ltr,
      children: [
        GestureDetector(
          onTap: onSpeedTap,
          child: Text(
            speed == speed.roundToDouble() ? '${speed.toInt()}x' : '${speed}x',
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: Colors.white30,
              inactiveTrackColor: Colors.white,
              thumbColor: Colors.white,
            ),
            child: Slider(
              value: position.inSeconds.clamp(0, total.inSeconds).toDouble(),
              min: 0,
              max: total.inSeconds > 0 ? total.inSeconds.toDouble() : 1,
              onChanged: (value) =>
                  audioService.seek(Duration(seconds: value.toInt())),
            ),
          ),
        ),
      ],
    );
  }
}
