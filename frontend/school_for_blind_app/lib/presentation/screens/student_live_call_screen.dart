import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';

class StudentLiveCallScreen extends StatefulWidget {
  const StudentLiveCallScreen({super.key});

  @override
  State<StudentLiveCallScreen> createState() => _StudentLiveCallScreenState();
}

class _StudentLiveCallScreenState extends State<StudentLiveCallScreen> {
  Room? _room;
  bool _isMuted = false;
  bool _isConnected = false;

  Timer? _timer;
  int _secondsElapsed = 0;

  late String token;
  late String roomName;
  late String startedAt;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    token = args['token'];
    roomName = args['room_name'];
    startedAt = args['started_at'];

    if (_room == null) {
      _initLiveKitAndConnect();
    }
  }

  Future<void> _initLiveKitAndConnect() async {
    final status = await Permission.microphone.request();
    if (status.isDenied) {
      getIt<VoiceServices>().speak(
        "يجب السماح بصلاحية المايكروفون للانضمام للمكالمة",
      );
      Navigator.pop(context);
      return;
    }

    try {
      _room = Room();

      await _room!.connect(
        'https://school-for-blind-vd3kp8u7.livekit.cloud',
        token,
        roomOptions: const RoomOptions(
          defaultAudioPublishOptions: AudioPublishOptions(dtx: true),
          defaultAudioCaptureOptions: AudioCaptureOptions(
            echoCancellation: true,
            noiseSuppression: true,
          ),
        ),
      );

      await _room!.localParticipant?.setMicrophoneEnabled(true);

      if (mounted) {
        setState(() {
          _isConnected = true;
        });
        _startTimer();
        getIt<VoiceServices>().speak("تم الانضمام إلى المكالمة بنجاح");
      }
    } catch (e) {
      print("خطأ تفصيلي أثناء اتصال LiveKit: $e");

      if (mounted) {
        getIt<VoiceServices>().speak("فشل الاتصال بالبث الصوتي");
        Navigator.pop(context);
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  String _formatDuration(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  Future<void> _toggleMute() async {
    if (_room == null) return;
    final newMuteState = !_isMuted;
    await _room!.localParticipant?.setMicrophoneEnabled(!newMuteState);

    setState(() {
      _isMuted = newMuteState;
    });

    getIt<VoiceServices>().speak(
      newMuteState ? "تم كتم الصوت" : "تم تشغيل الصوت",
    );
  }

  Future<void> _disconnectAndExit() async {
    _timer?.cancel();
    await _room?.disconnect();
    getIt<VoiceServices>().speak("تم مغادرة المكالمة");
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _room?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(roomName, style: AppTextStyles.kMediumPrimary(context)),
                  Text(
                    _isConnected
                        ? _formatDuration(_secondsElapsed)
                        : "جاري الاتصال...",
                    style: AppTextStyles.kBigPrimary(context),
                  ),
                  Text(
                    "وقت البدء: ${startedAt.substring(11)}",
                    style: AppTextStyles.kMediumPrimary(context),
                  ),
                ],
              ),
              Semantics(
                label: _isConnected ? "بث صوتي جاري حالياً" : "جاري تحميل البث",
                child: Container(
                  width: double.infinity,
                  height: 200.h,
                  color: Theme.of(context).colorScheme.background,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(35, (index) {
                            final heights = [
                              20.h,
                              40.h,
                              15.h,
                              30.h,
                              55.h,
                              70.h,
                              45.h,
                              20.h,
                              35.h,
                              60.h,
                              80.h,
                              50.h,
                              25.h,
                              40.h,
                              65.h,
                              30.h,
                              20.h,
                              55.h,
                              75.h,
                              40.h,
                              15.h,
                              30.h,
                              60.h,
                              85.h,
                              50.h,
                              20.h,
                              45.h,
                              70.h,
                              35.h,
                              25.h,
                              55.h,
                              80.h,
                              40.h,
                              15.h,
                              30.h,
                              65.h,
                              45.h,
                              20.h,
                              35.h,
                              50.h,
                              75.h,
                              40.h,
                              20.h,
                              30.h,
                              15.h,
                            ];
                            return Container(
                              width: 3.w,
                              height: heights[index % heights.length],
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onBackground.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Semantics(
                    label: _isMuted ? "تشغيل المايكروفون" : "كتم المايكروفون",
                    button: true,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isMuted
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surface,
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                        fixedSize: Size(80.r, 80.r),
                      ),
                      onPressed: _isConnected ? _toggleMute : null,
                      child: Center(
                        child: FaIcon(
                          _isMuted
                              ? FontAwesomeIcons.microphoneSlash
                              : FontAwesomeIcons.microphone,
                          size: 35.sp,
                          color: _isMuted
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  Semantics(
                    label: "خروج من المكالمة",
                    button: true,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFf3333),
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                        fixedSize: Size(80.r, 80.r),
                      ),
                      onPressed: _disconnectAndExit,
                      child: Center(
                        child: Icon(
                          Icons.call_end,
                          color: Colors.white,
                          size: 35.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
