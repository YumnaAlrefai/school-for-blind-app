import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:school_for_blind_app/core/services/lesson_audio_service.dart';


class VoiceMessagePlayer extends StatefulWidget {
  final String audioUrl;

  final Color color;

  const VoiceMessagePlayer({
    super.key,
    required this.audioUrl,
    this.color = Colors.white,
  });

  @override
  State<VoiceMessagePlayer> createState() => _VoiceMessagePlayerState();
}

class _VoiceMessagePlayerState extends State<VoiceMessagePlayer> {
  final AudioPlayer _player = AudioPlayer();

  // خيارات التسريع (نفس فكرة الدروس)
  static const List<double> _speeds = [1.0, 1.5, 2.0];
  int _speedIndex = 0;

  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await _player.setUrl(widget.audioUrl);
      if (mounted) setState(() => _ready = true);
    } catch (_) {
      // يبقى غير جاهز — يظهر زر معطّل
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (!_ready) return;
    // إعادة التشغيل من البداية إن انتهى
    if (_player.processingState == ProcessingState.completed) {
      await _player.seek(Duration.zero);
    }
    _player.playing ? await _player.pause() : await _player.play();
  }

  Future<void> _cycleSpeed() async {
    _speedIndex = (_speedIndex + 1) % _speeds.length;
    await _player.setSpeed(_speeds[_speedIndex]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final speed = _speeds[_speedIndex];

    return SizedBox(
      width: 240,
      child: Column(
        children: [
          // صف: زر تشغيل + سلايدر
          StreamBuilder<Duration>(
            stream: _player.positionStream,
            builder: (context, posSnap) {
              final position = posSnap.data ?? Duration.zero;
              final total = _player.duration ?? Duration.zero;
              final maxSec =
                  total.inSeconds > 0 ? total.inSeconds.toDouble() : 1.0;
              final value =
                  position.inSeconds.clamp(0, total.inSeconds).toDouble();

              return Row(
                textDirection: TextDirection.ltr,
                children: [
                  // زر التشغيل/الإيقاف
                  StreamBuilder<PlayerState>(
                    stream: _player.playerStateStream,
                    builder: (context, stateSnap) {
                      final playing = stateSnap.data?.playing ?? false;
                      return GestureDetector(
                        onTap: _toggle,
                        child: Icon(
                          playing
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
                          size: 33,
                          color: widget.color,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 7),
                        overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 12),
                        activeTrackColor: widget.color.withOpacity(0.9),
                        inactiveTrackColor: widget.color.withOpacity(0.3),
                        thumbColor: widget.color,
                      ),
                      child: Slider(
                        value: value,
                        min: 0,
                        max: maxSec,
                        onChanged: _ready
                            ? (v) =>
                                _player.seek(Duration(seconds: v.toInt()))
                            : null,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          // صف: الوقت + التسريع
          StreamBuilder<Duration>(
            stream: _player.positionStream,
            builder: (context, snap) {
              final position = snap.data ?? Duration.zero;
              final total = _player.duration ?? Duration.zero;
              return Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // التسريع
                  GestureDetector(
                    onTap: _cycleSpeed,
                    child: Text(
                      speed == speed.roundToDouble()
                          ? '${speed.toInt()}x'
                          : '${speed}x',
                      style: TextStyle(color: widget.color, fontSize: 13),
                    ),
                  ),
                  // الوقت الحالي / الإجمالي
                  Text(
                    '${LessonAudioService.formatTime(position)} / '
                    '${LessonAudioService.formatTime(total)}',
                    style: TextStyle(
                        color: widget.color.withOpacity(0.75), fontSize: 12),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}