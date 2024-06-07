import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:vent/src/config.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceService {
  VoiceService();

  final stt.SpeechToText _speech = stt.SpeechToText();

  // void init(Function loaded, Function(String append) onResult, Function(dynamic e) onError, Function(int duration) onTimerUpdate) {
  //   speech = stt.SpeechToText();
  // }

  Future<void> start(Function loaded, Function(String status) onStatus, Function(SpeechRecognitionResult append) onResult, Function(dynamic e) onError) async {
    bool available = await _speech.initialize( onStatus: onStatus, onError: onError );
    if ( available ) {
      _speech.listen( onResult: onResult );
    }
    else {
      onError("Permission denied");
    }
  }

  void stop() async {
    await _speech.stop();
  }

  void dispose() {

  }
}