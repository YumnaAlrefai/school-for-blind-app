import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/audio_bookmark.dart';
import 'package:school_for_blind_app/data/models/record_model.dart';
import 'package:school_for_blind_app/presentation/widgets/audio_bookmarks_list.dart';
import 'package:school_for_blind_app/presentation/widgets/audio_wave_form.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/flag_with_add_icon.dart';

class StudentAudioPlayerScreen extends StatefulWidget {
  final String lessonName;
  final RecordModel record;

  const StudentAudioPlayerScreen({
    super.key,
    required this.lessonName,
    required this.record,
  });

  @override
  State<StudentAudioPlayerScreen> createState() =>
      _StudentAudioPlayerScreenState();
}

class _StudentAudioPlayerScreenState extends State<StudentAudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;
  bool _showBookmarks = false;

  final List<AudioBookmark> _bookmarks = [];
  final List<double> _speeds = [0.5, 1.0, 1.5, 2.0];
  int _currentSpeedIndex = 1;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudio();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initAudio() async {
    try {
      await _audioPlayer.setUrl(widget.record.url);

      _audioPlayer.playerStateStream.listen((playerState) {
        if (mounted) {
          setState(() {
            _isPlaying = playerState.playing;
            if (playerState.processingState == ProcessingState.completed) {
              _audioPlayer.seek(Duration.zero);
              _audioPlayer.pause();
              _currentPosition = Duration.zero;
            }
          });
        }
      });

      _audioPlayer.positionStream.listen((position) {
        if (mounted) setState(() => _currentPosition = position);
      });

      _audioPlayer.durationStream.listen((duration) {
        if (mounted) setState(() => _totalDuration = duration ?? Duration.zero);
      });
    } catch (e) {
      debugPrint("خطأ أثناء تحميل ملف الصوت: $e");
    }
  }

  void _changeSpeed() {
    setState(() {
      _currentSpeedIndex = (_currentSpeedIndex + 1) % _speeds.length;
    });
    _audioPlayer.setSpeed(_speeds[_currentSpeedIndex]);
  }

  void _addNewBookmark() {
    setState(() {
      _bookmarks.add(
        AudioBookmark(position: _currentPosition, isEditing: false),
      );
      _bookmarks.sort((a, b) => a.position.compareTo(b.position));
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(helpMessage: ''),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Text(
            '(${widget.lessonName})',
            style: AppTextStyles.kMediumPrimary(context),
          ),
          SizedBox(
            height: 66.h,
            child: Text(
              _formatDuration(_currentPosition),
              style: const TextStyle(fontSize: 64),
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 60.h,
            child: Text(
              _formatDuration(_totalDuration),
              style: AppTextStyles.kMediumPrimary(context),
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () =>
                      setState(() => _showBookmarks = !_showBookmarks),
                  icon: FaIcon(
                    _showBookmarks
                        ? FontAwesomeIcons.solidFlag
                        : FontAwesomeIcons.flag,
                    size: 34.r,
                  ),
                  color: _showBookmarks
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onBackground,
                ),
                TextButton(
                  onPressed: _changeSpeed,
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onBackground,
                  ),
                  child: Text(
                    'x${_speeds[_currentSpeedIndex]}',
                    style: AppTextStyles.kMediumPrimary(context),
                  ),
                ),
                IconButton(
                  onPressed: _addNewBookmark,
                  icon: const FlagWithAddIcon(),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          _showBookmarks
              ? AudioBookmarksList(
                  bookmarks: _bookmarks,
                  formatDuration: _formatDuration,
                  onBookmarkTap: (pos) async => await _audioPlayer.seek(pos),
                  onDelete: (index) =>
                      setState(() => _bookmarks.removeAt(index)),
                  onStateChanged: () => setState(() {}),
                )
              : AudioWaveForm(
                  position: _currentPosition,
                  duration: _totalDuration,
                  bookmarkPositions: _bookmarks.map((b) => b.position).toList(),
                  onSeek: (newPosition) => _audioPlayer.seek(newPosition),
                ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 20.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.forward_10,
                          color: Theme.of(context).colorScheme.onBackground,
                          size: 50,
                        ),
                        onPressed: () {
                          final newPosition =
                              _currentPosition + const Duration(seconds: 10);
                          _audioPlayer.seek(
                            newPosition < _totalDuration
                                ? newPosition
                                : _totalDuration,
                          );
                        },
                      ),
                      SizedBox(width: 15.w),
                      GestureDetector(
                        onTap: () => _isPlaying
                            ? _audioPlayer.pause()
                            : _audioPlayer.play(),
                        child: Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onBackground,
                              width: 3,
                            ),
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Theme.of(context).colorScheme.onBackground,
                            size: 50,
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      IconButton(
                        icon: Icon(
                          Icons.replay_10,
                          color: Theme.of(context).colorScheme.onBackground,
                          size: 50,
                        ),
                        onPressed: () {
                          final newPosition =
                              _currentPosition - const Duration(seconds: 10);
                          _audioPlayer.seek(
                            newPosition > Duration.zero
                                ? newPosition
                                : Duration.zero,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
