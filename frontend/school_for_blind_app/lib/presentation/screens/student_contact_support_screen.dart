import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_buttons.dart';
import 'package:school_for_blind_app/presentation/widgets/options_card.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';

class StudentContactSupportScreen extends StatefulWidget {
  const StudentContactSupportScreen({super.key});

  @override
  State<StudentContactSupportScreen> createState() =>
      _StudentContactSupportScreenState();
}

class _StudentContactSupportScreenState
    extends State<StudentContactSupportScreen> {
  bool _isSpeechMode = false;
  bool _isRecording = false;
  bool _hasRecorded = false;
  bool _isPlaying = false;
  String? _audioPath;

  TextEditingController controller = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _audioRecorder = AudioRecorder();

  XFile? _problemImg;

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _problemImg = image;
        getIt<VoiceServices>().speak('تم إرفاق الصورة بنجاح');
      });
    }
  }

  Future<void> _handleRecording() async {
    try {
      if (!_isRecording) {
        if (await _audioRecorder.hasPermission()) {
          await HapticFeedback.vibrate();
          final directory = await getTemporaryDirectory();
          final filePath =
              '${directory.path}/student_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
          await _audioRecorder.start(const RecordConfig(), path: filePath);
          setState(() {
            _isRecording = true;
            _audioPath = filePath;
          });
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
  void initState() {
    super.initState();
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: CustomAppBar(helpMessage: ''),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Text(
              'صِف المشكلة:',
              style: AppTextStyles.kMediumPrimary(context),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: !_isSpeechMode
                  ? Stack(
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
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: controller,
                            maxLines: null,
                            style: TextStyle(
                              fontSize: 35,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                            decoration: InputDecoration(
                              hintText: 'أواجه مشكلة في..',
                              hintStyle: TextStyle(
                                fontSize: 35,
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
                          top: 5,
                          left: 5,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _isSpeechMode = true;
                              });
                            },
                            icon: Icon(
                              Icons.mic,
                              size: 34,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      key: const ValueKey(2),
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: !_hasRecorded
                              ? _buildInputAndMicSection()
                              : _buildAudioPlayerSection(),
                        ),
                        Positioned(
                          top: 5,
                          left: 5,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _isSpeechMode = false;
                              });
                            },
                            icon: Icon(
                              Icons.keyboard,
                              size: 34,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Text(
              'لقطة شاشة للمشكلة (اختياري):',
              style: AppTextStyles.kMediumPrimary(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _problemImg == null
                    ? OptionsCard(
                        icon: Icons.add_photo_alternate_outlined,
                        iconSize: 45,
                        height: 200,
                        width: 200,
                        isSelected: false,
                        onTap: () async {
                          _pickImageFromGallery();
                        },
                      )
                    : SizedBox(
                        height: 120,
                        width: 200,
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(_problemImg!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: IconButton(
                                iconSize: 20,
                                style: IconButton.styleFrom(
                                  backgroundColor: Color(0xffff3333),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _problemImg = null;
                                    getIt<VoiceServices>().speak(
                                      'تم حذف الصورة',
                                    );
                                  });
                                },
                                icon: Icon(Icons.close, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(height: 5.h),
          Center(
            child: PrimaryButton(
              title: 'إرسال',
              width: 332,
              height: 97,
              onPressed: () {},
              fontSize: 48,
            ),
          ),
          SizedBox(height: 0),
        ],
      ),
    );
  }

  SizedBox _buildInputAndMicSection() {
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
              radius: 35,
              backgroundColor: _isRecording
                  ? Color(0xffff3333)
                  : Theme.of(context).colorScheme.primary,
              child: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: _isRecording
                    ? Colors.white
                    : Theme.of(context).colorScheme.onPrimary,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildAudioPlayerSection() {
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
                      minHeight: 6,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await _audioPlayer.stop();
                    getIt<VoiceServices>().speak('تم حذف التسجيل الصوتي');
                    setState(() {
                      _hasRecorded = false;
                      _isPlaying = false;
                      _audioPath = null;
                    });
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 34.sp,
                    color: Color(0xFFFf3333),
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
