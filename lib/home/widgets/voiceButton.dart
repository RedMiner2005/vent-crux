import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vent/src/repository/repository.dart';

class VoiceButton extends StatefulWidget {
  const VoiceButton({super.key, required this.voiceService, required this.controller});

  final VoiceService voiceService;
  final TextEditingController controller;

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton> {
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          if(!isRecording) {
            // _voiceService?.start();
            widget.voiceService.start(
                  () {},
                  (status) => null,
                  (append) {
                widget.controller.text = append.recognizedWords;
              },
                  (e) {
                Fluttertoast.showToast(msg: "Recording error");
                log("Recording error: ${e.toString()}");
                setState(() {
                  isRecording = false;
                });
              },
            );
            setState(() => isRecording = true);
          } else {
            widget.voiceService.stop();
            setState(() => isRecording = false);
          }

        },
        icon: Icon(Icons.mic_rounded),
        label: Text((isRecording) ? "Stop" : "Voice")
    );
  }
}
