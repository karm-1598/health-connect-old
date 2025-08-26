import 'dart:async';

import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';

// Enum for microphone icon states
enum MicrophoneState {
  idle,
  listening,
  success,
  error,
}

class SpeechController extends GetxController {
  final SpeechToText _speechToText = SpeechToText();
  final RxBool startRecord = false.obs;
  final RxBool isAvailable = false.obs;
  final RxString recordedText = ''.obs;
  final Rx<MicrophoneState> microphoneState = MicrophoneState.idle.obs;
  DateTime? _lastSpeechTime;
  Function(String)? _currentOnResult;
  Timer? _silenceTimer;

  @override
  void onClose() {
    _silenceTimer?.cancel();
    _speechToText.stop();
    super.onClose();
  }

  Future<void> initSpeech() async {
    isAvailable.value = await _speechToText.initialize();
  }

  void startListening(Function(String) onResult) {
    _currentOnResult = onResult;
    startRecord.value = true;
    recordedText.value = 'Listening...';
    microphoneState.value = MicrophoneState.listening;
    _lastSpeechTime = DateTime.now();
    
    _startSilenceTimer();

    if (isAvailable.value) {
      _speechToText.listen(
        onResult: (result) {
          // Update last speech time when we get results
          _lastSpeechTime = DateTime.now();
          _resetSilenceTimer();
          
          if (result.recognizedWords.isNotEmpty) {
            recordedText.value = result.recognizedWords;
            onResult(result.recognizedWords);
            
            // Change to success state when we have final results
            if (result.finalResult) {
              microphoneState.value = MicrophoneState.success;
              // Auto-close after successful recognition
              Future.delayed(const Duration(seconds: 1), () {
                if (startRecord.value) {
                  cancelListening();
                  Get.back();
                }
              });
            }
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        onSoundLevelChange: (level) {
          // Reset timer when sound is detected
          if (level > 0) {
            _lastSpeechTime = DateTime.now();
            _resetSilenceTimer();
          }
        },
        cancelOnError: true,
        partialResults: true,
        listenMode: ListenMode.dictation,
              );
    }
  }

  void _startSilenceTimer() {
    _silenceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_lastSpeechTime != null &&
          DateTime.now().difference(_lastSpeechTime!).inSeconds >= 3 &&
          startRecord.value) {
        // No speech detected for 3 seconds
        timer.cancel();
        if (recordedText.value.isEmpty || recordedText.value == 'Listening...') {
          recordedText.value = 'No speech detected';
          microphoneState.value = MicrophoneState.error;
          
          // Auto-close after 3 seconds of silence
          Future.delayed(const Duration(seconds: 1), () {
            if (startRecord.value) {
              cancelListening();
              Get.back();
            }
          });
        }
      }
    });
  }

  void _resetSilenceTimer() {
    _silenceTimer?.cancel();
    _startSilenceTimer();
  }

  void cancelListening() {
    _silenceTimer?.cancel();
    startRecord.value = false;
    microphoneState.value = MicrophoneState.idle;
    _speechToText.stop();
  }
}