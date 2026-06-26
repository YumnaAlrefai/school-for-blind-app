import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/audio_bookmark.dart';
import 'package:school_for_blind_app/presentation/widgets/audio_wave_form.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_app_bar.dart';

class StudentAudioPlayerScreen extends StatefulWidget {
  final String lessonName;
  final int recordNumber;

  const StudentAudioPlayerScreen({
    super.key,
    required this.lessonName,
    required this.recordNumber,
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

  /////////////////////////بدو تعديل لما اربط مع الباك
  Future<void> _initAudio() async {
    try {
      await _audioPlayer.setUrl(
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      );

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
          Row(
            children: [
              SizedBox(width: 30.w),
              Text(
                '${widget.lessonName} (${widget.recordNumber})',
                style: AppTextStyles.kMediumPrimary(context),
              ),
            ],
          ),
          SizedBox(
            height: 66.h,
            child: Text(
              _formatDuration(_currentPosition),
              style: TextStyle(fontSize: 64),
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
                  onPressed: () {
                    setState(() {
                      _showBookmarks = !_showBookmarks;
                    });
                  },
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
                IconButton(onPressed: _addNewBookmark, icon: FlagWithAddIcon()),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          _showBookmarks
              ? _buildBookmarksList()
              : AudioWaveForm(
                  position: _currentPosition,
                  duration: _totalDuration,
                  bookmarkPositions: _bookmarks.map((b) => b.position).toList(),
                  onSeek: (newPosition) {
                    _audioPlayer.seek(newPosition);
                  },
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
                        onTap: () {
                          if (_isPlaying) {
                            _audioPlayer.pause();
                          } else {
                            _audioPlayer.play();
                          }
                        },
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

  Widget _buildBookmarksList() {
    if (_bookmarks.isEmpty) {
      return Container(
        height: 200.h,
        width: double.infinity,
        color: Theme.of(context).colorScheme.surface,
        alignment: Alignment.center,
        child: Text(
          "لا يوجد علامات مضافة",
          style: AppTextStyles.kMediumPrimary(context),
        ),
      );
    }

    return Container(
      height: 200.h,
      color: Theme.of(context).colorScheme.surface.withOpacity(0.6),

      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView.builder(
        itemCount: _bookmarks.length,
        itemBuilder: (context, index) {
          final bookmark = _bookmarks[index];
          return Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _bookmarks.removeAt(index);
                  });
                },
                icon: Icon(Icons.remove_circle_outline),
                color: Theme.of(context).colorScheme.onBackground,
                iconSize: 32,
              ),
              SizedBox(width: 10.w),
              GestureDetector(
                onTap: () async{
                  await _audioPlayer.seek(bookmark.position);
                },
                child: Text(
                  _formatDuration(bookmark.position),
                  style: TextStyle(fontSize: 40),
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: bookmark.isEditing
                    ? SizedBox(
                        height: 48.h,
                        child: TextField(
                          cursorHeight: 24,
                          controller: bookmark.controller,
                          autofocus: true,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 30,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.background,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1.5,
                              ),
                            ),
                          ),
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              bookmark.isEditing = false;
                              if (bookmark.controller.text.trim().isNotEmpty) {
                                bookmark.title = bookmark.controller.text
                                    .trim();
                              } else {
                                bookmark.title = "";
                              }
                            });
                          },
                          onSubmitted: (value) {
                            setState(() {
                              bookmark.isEditing = false;
                              if (value.trim().isNotEmpty) {
                                bookmark.title = value.trim();
                              } else {
                                bookmark.title = "";
                              }
                            });
                          },
                        ),
                      )
                    : ((bookmark.title != null) &&
                              ((bookmark.title!.isNotEmpty))
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  bookmark.isEditing = true;
                                });
                              },
                              child: Container(
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.background,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    bookmark.title!,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onBackground,
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  bookmark.isEditing = true;
                                });
                              },
                              child: Container(
                                height: 48.h,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      size: 25,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      "إضافة ملاحظة",
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FlagWithAddIcon extends StatelessWidget {
  const FlagWithAddIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        FaIcon(
          FontAwesomeIcons.flag,
          size: 34.r,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        Positioned(
          top: 6.h,
          left: 8.w,
          child: Icon(
            Icons.add,
            size: 14.r,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }
}
