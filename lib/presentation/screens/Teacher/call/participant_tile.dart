import 'package:flutter/material.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/call/call_models.dart';

import 'audio_waveform.dart';

const Color kSpeakingLime = Color(0xFFC8F526);

class ParticipantTile extends StatelessWidget {
  const ParticipantTile({
    super.key,
    required this.participant,
    required this.showModeration,
    this.onToggleMute,
    this.onKick,
  });

  final CallParticipant participant;
  final bool showModeration;
  final VoidCallback? onToggleMute;
  final VoidCallback? onKick;

  @override
  Widget build(BuildContext context) {
    if (!participant.isPresent) {
      return _NotJoinedTile(name: participant.name);
    }

    final speaking = participant.isSpeaking && participant.isMicEnabled;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16273D),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: speaking ? kSpeakingLime : Colors.transparent,
          width: 2,
        ),
        boxShadow: speaking
            ? [
                BoxShadow(
                  color: kSpeakingLime.withOpacity(0.35),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                if (showModeration)
                  _TileIconButton(
                    icon: Icons.person_remove_alt_1,
                    tooltip: 'طرد ${participant.name}',
                    onTap: onKick,
                  )
                else
                  const SizedBox(width: 30, height: 30),
                const Spacer(),
                if (showModeration)
                  _TileIconButton(
                    icon: participant.isMicEnabled ? Icons.mic : Icons.mic_off,
                    color: participant.isMicEnabled
                        ? Colors.white70
                        : kSpeakingLime,
                    tooltip:
                        '${participant.isMicEnabled ? 'كتم' : 'فك كتم'} ${participant.name}',
                    onTap: onToggleMute,
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      participant.isMicEnabled ? Icons.mic : Icons.mic_off,
                      size: 16,
                      color: participant.isMicEnabled
                          ? Colors.white38
                          : kSpeakingLime,
                    ),
                  ),
              ],
            ),
          ),
          const Spacer(),
          AudioWaveform(
            isActive: speaking,
            color: speaking ? kSpeakingLime : Colors.white30,
          ),
          const Spacer(),
          Text(
            participant.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: speaking ? kSpeakingLime : Colors.white,
              fontSize: 12,
              fontWeight: speaking ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotJoinedTile extends StatelessWidget {
  const _NotJoinedTile({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF101B2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_outline, color: Colors.white24, size: 24),
          const SizedBox(height: 6),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const SizedBox(height: 2),
          const Text(
            'لم ينضم بعد',
            style: TextStyle(color: Colors.white24, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _TileIconButton extends StatelessWidget {
  const _TileIconButton({
    required this.icon,
    required this.tooltip,
    this.onTap,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onTap,
        radius: 24,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18, color: color ?? Colors.white70),
        ),
      ),
    );
  }
}
