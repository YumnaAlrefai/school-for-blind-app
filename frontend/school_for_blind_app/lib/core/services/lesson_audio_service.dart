import 'package:just_audio/just_audio.dart';
 
/// خدمة تشغيل صوت واحدة لكل الشاشة (درس واحد يعمل في نفس الوقت)
class LessonAudioService {
  final AudioPlayer _player = AudioPlayer();
 
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Duration? get totalDuration => _player.duration;
  bool get isPlaying => _player.playing;
 
  Future<void> playUrl(String url, {double speed = 1.0}) async {
    await _player.stop();
    await _player.setUrl(url);
    await _player.setSpeed(speed);
    await _player.play();
  }
 
  Future<void> toggle() async =>
      _player.playing ? _player.pause() : _player.play();
 
  Future<void> stop() async => _player.stop();
 
  Future<void> seek(Duration position) async => _player.seek(position);
 
  Future<void> setSpeed(double speed) async => _player.setSpeed(speed);
 
  void dispose() => _player.dispose();
 
  /// تنسيق الوقت بشكل 45:00 أو 1:05:00
  static String formatTime(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return d.inHours > 0 ? '${d.inHours}:$minutes:$seconds' : '$minutes:$seconds';
  }
}