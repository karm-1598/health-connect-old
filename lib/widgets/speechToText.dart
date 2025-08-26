import 'dart:async';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:get/get.dart';
import 'package:health_connect2/controllers/speechController.dart';

class Speechtotext extends StatefulWidget {
  final Function(String) onResult;
  
  const Speechtotext({super.key, required this.onResult});

  @override
  State<Speechtotext> createState() => _SpeechtotextState();
}

class _SpeechtotextState extends State<Speechtotext> {
  final SpeechController controller = Get.put(SpeechController());
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    controller.initSpeech();
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  // Get the appropriate icon based on microphone state
  IconData _getMicrophoneIcon() {
    switch (controller.microphoneState.value) {
      case MicrophoneState.idle:
        return Icons.mic;
      case MicrophoneState.listening:
        return Icons.mic;
      case MicrophoneState.success:
        return Icons.check_circle;
      case MicrophoneState.error:
        return Icons.error;
    }
  }

  // Get the appropriate color based on microphone state
  Color _getMicrophoneColor() {
    switch (controller.microphoneState.value) {
      case MicrophoneState.idle:
        return Colors.blue;
      case MicrophoneState.listening:
        return Colors.orange;
      case MicrophoneState.success:
        return Colors.green;
      case MicrophoneState.error:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent closing by tapping outside
          builder: (context) {
            // Start listening after dialog is built
            Future.microtask(() => controller.startListening(widget.onResult));
            
            // Set up auto-close timer for 10 seconds maximum
            _autoCloseTimer = Timer(const Duration(seconds: 10), () {
              if (Get.isDialogOpen ?? false) {
                controller.cancelListening();
                Get.back();
              }
            });

            return PopScope(
              canPop: false, // Prevent back button from closing
              child: AlertDialog(
                insetPadding: const EdgeInsets.all(20),
                contentPadding: const EdgeInsets.all(24),
                title: Column(
                  children: [
                    Obx(() => AvatarGlow(
                      animate: controller.microphoneState.value == MicrophoneState.listening,
                      glowColor: _getMicrophoneColor(),
                      duration: const Duration(milliseconds: 2000),
                      repeat: true,
                      child: Icon(
                        _getMicrophoneIcon(),
                        size: 40,
                        color: _getMicrophoneColor(),
                      ),
                    )),
                    const SizedBox(height: 16),
                    const Text(
                      'Voice Search',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                content: Obx(() => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.recordedText.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    if (controller.microphoneState.value == MicrophoneState.listening)
                      const Text(
                        'Speak now...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    if (controller.microphoneState.value == MicrophoneState.error)
                      const Text(
                        'Tap outside to try again',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                )),
              ),
            );
          },
        ).then((_) {
          // Clean up when dialog closes
          _autoCloseTimer?.cancel();
          controller.cancelListening();
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.mic,
          color: Colors.blue,
        ),
      ),
    );
  }
}