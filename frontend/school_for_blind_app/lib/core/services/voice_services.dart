import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceServices {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  VoiceServices() {
    _flutterTts.setLanguage("ar");
    _flutterTts.setSpeechRate(0.5);
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  bool _isAvailable = false;

  Future<void> initVoice() async {
    _isAvailable = await _speechToText.initialize();
  }

  void startListening(Function(String) onResult) {
    if (_isAvailable) {
      _speechToText.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
      );
    }
  }

  void stopListening() => _speechToText.stop();
}
