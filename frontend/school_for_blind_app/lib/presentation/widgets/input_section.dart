import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';

class InputSection extends StatefulWidget {
  final TextEditingController controller;
  final String audioFilePrefix;
  final Function(String? path) onAudioChanged;
  final String hintText;

  const InputSection({
    super.key,
    required this.controller,
    required this.audioFilePrefix,
    required this.onAudioChanged,
    required this.hintText,
  });

  @override
  State<InputSection> createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  bool _isSpeechMode = false;
  bool _isRecording = false;
  bool _hasRecorded = false;
  bool _isPlaying = false;
  String? _audioPath;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _audioRecorder = AudioRecorder();
  late StreamSubscription _playerSubscription;

  @override
  void initState() {
    super.initState();
    _playerSubscription = _audioPlayer.onPlayerComplete.listen((event) {
      setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _playerSubscription.cancel();
    _audioPlayer.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _clearAudioTracks() async {
    if (_isPlaying) await _audioPlayer.stop();
    setState(() {
      _hasRecorded = false;
      _isPlaying = false;
      _audioPath = null;
    });
    widget.onAudioChanged(null);
  }

  Future<void> _handleRecording() async {
    try {
      if (!_isRecording) {
        if (await _audioRecorder.hasPermission()) {
          if (widget.controller.text.isNotEmpty) {
            widget.controller.clear();
          }

          await HapticFeedback.vibrate();
          final directory = await getTemporaryDirectory();
          final filePath =
              '${directory.path}/${widget.audioFilePrefix}_${DateTime.now().millisecondsSinceEpoch}.m4a';
          await _audioRecorder.start(const RecordConfig(), path: filePath);
          setState(() {
            _isRecording = true;
            _audioPath = filePath;
          });
          widget.onAudioChanged(_audioPath);
        } else {
          getIt<VoiceServices>().speak('يرجى إعطاء صلاحية المايكروفون للتطبيق');
        }
      } else {
        await HapticFeedback.vibrate();
        await Future.delayed(const Duration(milliseconds: 200));
        await HapticFeedback.vibrate();
        final path = await _audioRecorder.stop();
        setState(() {
          _isRecording = false;
          _hasRecorded = true;
          _audioPath = path;
        });
        widget.onAudioChanged(_audioPath);
      }
    } catch (e) {
      print("خطأ أثناء التسجيل: $e");
    }
  }

  Future<void> _togglePlayback() async {
    if (_audioPath == null) return;
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        setState(() => _isPlaying = false);
      } else {
        await _audioPlayer.play(DeviceFileSource(_audioPath!));
        setState(() => _isPlaying = true);
      }
    } catch (e) {
      print("خطأ في تشغيل الصوت: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: !_isSpeechMode
          ? _buildKeyboardInputSection()
          : _buildVoiceInputSection(),
    );
  }

  Widget _buildKeyboardInputSection() {
    return Stack(
      children: [
        Container(
          key: const ValueKey(3),
          width: 332.w,
          height: 170.h,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            maxLines: null,
            style: TextStyle(
              fontSize: 35.sp,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: 35.sp,
                color: Theme.of(
                  context,
                ).colorScheme.onBackground.withOpacity(0.7),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: 15.h,
                horizontal: 20.w,
              ),
            ),
          ),
        ),
        Positioned(
          top: 5.h,
          left: 5.w,
          child: IconButton(
            onPressed: () {
              widget.controller.clear();
              setState(() {
                _isSpeechMode = true;
                _hasRecorded = false;
                _audioPath = null;
                _isRecording = false;
                _isPlaying = false;
              });
              widget.onAudioChanged(null);
              getIt<VoiceServices>().speak('تم الانتقال لتسجيل الصوت');
            },
            icon: Icon(
              Icons.mic,
              size: 34.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceInputSection() {
    return Stack(
      key: const ValueKey(2),
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: !_hasRecorded ? _buildMicButton() : _buildAudioPlayer(),
        ),
        Positioned(
          top: 5.h,
          left: 5.w,
          child: IconButton(
            onPressed: () async {
              if (_hasRecorded) {
                await _clearAudioTracks();
              }
              setState(() => _isSpeechMode = false);
              widget.controller.clear();
              getIt<VoiceServices>().speak('تم الانتقال للكتابة');
            },
            icon: Icon(
              Icons.keyboard,
              size: 34.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMicButton() {
    return SizedBox(
      width: 332.w,
      height: 170.h,
      child: Center(
        child: AvatarGlow(
          animate: _isRecording,
          glowColor: Theme.of(context).colorScheme.primary,
          duration: const Duration(milliseconds: 2000),
          repeat: true,
          child: GestureDetector(
            onTap: _handleRecording,
            child: CircleAvatar(
              radius: 35.r,
              backgroundColor: _isRecording
                  ? const Color(0xffff3333)
                  : Theme.of(context).colorScheme.primary,
              child: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: _isRecording
                    ? Colors.white
                    : Theme.of(context).colorScheme.onPrimary,
                size: 40.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAudioPlayer() {
    return Container(
      width: 332.w,
      height: 170.h,
      key: const ValueKey(4),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            height: 80.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Theme.of(context).colorScheme.primary),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.2),
                  child: IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: _togglePlayback,
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: _isPlaying ? null : 0.0,
                      backgroundColor: Theme.of(context).colorScheme.background,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                      minHeight: 6.h,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await _clearAudioTracks();
                    getIt<VoiceServices>().speak('تم حذف التسجيل الصوتي');
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 34.sp,
                    color: const Color(0xFFFf3333),
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
