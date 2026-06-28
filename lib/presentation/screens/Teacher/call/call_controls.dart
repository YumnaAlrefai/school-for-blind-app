import 'package:flutter/material.dart';

import 'participant_tile.dart' show kSpeakingLime;

/// شريط التحكّم السفلي للمدرس على شكل كبسولة.
/// الترتيب البصري (يسار ← يمين): إنهاء | ميكروفون المدرس | كتم كل الطلاب.
class CallControls extends StatelessWidget {
  const CallControls({
    super.key,
    required this.selfMicEnabled,
    required this.allStudentsMuted,
    required this.onEndCall,
    required this.onToggleSelfMic,
    required this.onToggleMuteAll,
  });

  final bool selfMicEnabled;
  final bool allStudentsMuted;
  final VoidCallback onEndCall;
  final VoidCallback onToggleSelfMic;
  final VoidCallback onToggleMuteAll;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF14202F),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white10),
        ),
        // تثبيت LTR ليبقى زر الإنهاء يساراً وكتم الطلاب يميناً كما في التصميم.
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // يسار: إنهاء المكالمة
              _ControlButton(
                icon: Icons.call_end,
                background: const Color(0xFFE53935),
                iconColor: Colors.white,
                tooltip: 'إنهاء المكالمة',
                onTap: onEndCall,
              ),
              // وسط: ميكروفون المدرس
              _ControlButton(
                icon: selfMicEnabled ? Icons.mic : Icons.mic_off,
                background:
                    selfMicEnabled ? const Color(0xFF26374A) : kSpeakingLime,
                iconColor: selfMicEnabled ? Colors.white : Colors.black,
                tooltip: selfMicEnabled ? 'كتم صوتي' : 'فك كتم صوتي',
                onTap: onToggleSelfMic,
              ),
              // يمين: كتم كل الطلاب
              _ControlButton(
                icon: allStudentsMuted
                    ? Icons.voice_over_off
                    : Icons.record_voice_over,
                background:
                    allStudentsMuted ? kSpeakingLime : const Color(0xFF26374A),
                iconColor: allStudentsMuted ? Colors.black : Colors.white,
                tooltip:
                    allStudentsMuted ? 'فك كتم كل الطلاب' : 'كتم كل الطلاب',
                onTap: onToggleMuteAll,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final Color background;
  final Color iconColor;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onTap,
        radius: 38,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(color: background, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 26),
        ),
      ),
    );
  }
}