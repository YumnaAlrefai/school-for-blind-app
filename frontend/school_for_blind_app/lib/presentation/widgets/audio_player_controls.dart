import 'package:audioplayers/audioplayers.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:flutter/foundation.dart';

class VoicePlayerManager {
  VoicePlayerManager({required this.onChange});

  final AudioPlayer player = AudioPlayer();
  final VoidCallback onChange;

  final Map<String, Duration> _durationCache = {};

  String? currentUrl;
  PlayerState playerState = PlayerState.stopped;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  void init() {
    player.onPlayerStateChanged.listen((state) {
      playerState = state;
      onChange();
    });

    player.onPositionChanged.listen((pos) {
      if (currentUrl == null) return;
      position = pos;
      onChange();
    });

    player.onDurationChanged.listen((dur) {
      duration = dur;
      if (currentUrl != null) {
        _durationCache[currentUrl!] = dur;
      }
      onChange();
    });

    player.onPlayerComplete.listen((_) async {
      if (currentUrl != null && duration > Duration.zero) {
        _durationCache[currentUrl!] = duration;
      }
      currentUrl = null;
      position = Duration.zero;
      onChange();

      try {
        await player.stop();
      } catch (_) {}
    });
  }

  Duration? cachedDurationOf(String url) => _durationCache[url];

  Future<void> toggle(String url) async {
    try {
      if (currentUrl == url && playerState == PlayerState.playing) {
        await player.pause();
        return;
      }
      if (currentUrl == url && playerState == PlayerState.paused) {
        await player.resume();
        return;
      }
      if (playerState == PlayerState.playing ||
          playerState == PlayerState.paused) {
        await player.stop();
      }

      currentUrl = url;
      position = Duration.zero;
      duration = _durationCache[url] ?? Duration.zero;
      onChange();

      await player.play(UrlSource(url));
    } catch (e) {
      currentUrl = null;
      onChange();
      getIt<VoiceServices>().speak('تعذر تشغيل المقطع الصوتي');
    }
  }

  void dispose() {
    player.dispose();
  }
}

void setupAudioPlayerListeners({
  required AudioPlayer player,
  required Function() onComplete,
  required Function(Duration pos) onPosition,
  required Function(Duration dur) onDuration,
}) {
  player.onPlayerComplete.listen((event) async {
    try {
      await player.stop();
    } catch (_) {}
    onComplete();
  });

  player.onPositionChanged.listen((pos) {
    if (player.state == PlayerState.completed) return;
    onPosition(pos);
  });

  player.onDurationChanged.listen((dur) => onDuration(dur));
}

Future<void> togglePlay({
  required String url,
  required AudioPlayer player,
  required String? currentlyPlayingUrl,
  required Function(String? newUrl) onStateChange,
}) async {
  try {
    if (currentlyPlayingUrl == url && player.state == PlayerState.playing) {
      await player.pause();
      onStateChange(url);
      return;
    }
    if (currentlyPlayingUrl == url && player.state == PlayerState.paused) {
      await player.resume();
      onStateChange(url);
      return;
    }
    await player.stop();
    onStateChange(url);
    await player.play(UrlSource(url));
  } catch (e) {
    onStateChange(null);
    getIt<VoiceServices>().speak('تعذر تشغيل المقطع الصوتي');
  }
}
