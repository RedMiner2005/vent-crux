import 'dart:developer';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vent/app/app.dart';
import 'package:vent/src/config.dart';
import 'package:vent/src/repository/authService.dart';
import 'package:vent/src/repository/contactService.dart';
import 'package:vent/src/repository/repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required AuthenticationService authService, required BackendService backendService, required VoiceService voiceService, required ContactService contactService, required TextEditingController controller}) :
        _authService = authService,
        _backendService = backendService,
        _voiceService = voiceService,
        _contactService = contactService,
        _controller = controller,
        super(HomeState.initial());

  final AuthenticationService _authService;
  final BackendService _backendService;
  final VoiceService _voiceService;
  final ContactService _contactService;
  final TextEditingController _controller;

  Future<Map<String, dynamic>> process() async {
    try {
      final result = await _backendService.process(_controller.text);
      log(result.toString());
      final matches = await _contactService.findMatches(result["contact"]);
      return {"result": result, "matches": matches};
    } catch (e) {
      if (e is FormatException) {
        _contactService.sync();
      }
      showMessage("Something went wrong. Try again.", "Processing issue: ${e.toString()}");
      // Fluttertoast.showToast(msg: "Could not process your request. Try again.");
      return {};
    }
  }

  Future<void> send(Map<String, dynamic> processData, String chosenHash) async {
    _backendService.send(chosenHash, processData["result"]["toSend"]);
  }

  void showMessage(String userMessage, String logMessage, {bool persistent=false, HomeState? newState}) {
    log(logMessage);
    if (newState == null)
      newState = state;
    emit(newState.copyWith(isRecording: false, message: userMessage));
    if (!persistent)
      Future.delayed(5.seconds, () => emit(state.copyWith(message: VentConfig.greetingSecondaryText)));
  }

  void onPageChanged(int newIndex) {
    bool? doIntroAnimation = null;
    if(state.status == HomeStatus.notifications && newIndex == 0) {
      _authService.clearUnread();
      doIntroAnimation = false;
    }
    emit(state.copyWith(status: HomeStatus.values[newIndex], doIntroAnimation: doIntroAnimation));
  }

  void onVoiceButtonPressed() {
    if(!state.isRecording) {
      _voiceService.start(
            () {},
            (status) => null,
            (append) {
          _controller.text = append.recognizedWords;
        },
        (e) {
          showMessage("Try speaking louder", "Recording error: ${e.toString()}");
        },
      );
      emit(state.copyWith(isRecording: true));
    } else {
      _voiceService.stop();
      emit(state.copyWith(isRecording: false));
    }
  }

  Future<void> onSendButtonPressed() async {
    showMessage("Processing...", "Processing started.", persistent: true, newState: state.copyWith(isProcessing: true));
    final processData = await process();
    if (processData == {}) {
      return;
    }
    if (processData["result"]["isValid"] != true) {
      showMessage(
          VentConfig.invalidPromptList[math.Random().nextInt(VentConfig.invalidPromptList.length)],
          "Invalid prompt: ${processData["result"]}",
          newState: state.copyWith(isProcessing: false)
      );
      return;
    }
    showMessage("Test Thing", "${processData["result"]}", newState: state.copyWith(isProcessing: false));
    return;
    String? chosenHash;
    log(processData["matches"].toString());
    if(processData["matches"].length == 1) {
      chosenHash = processData["matches"][0]["hash"];
    } else {
      // chosenHash = await context.push("/contactDialog", extra: processData["matches"]);
      if (chosenHash == null) {
        Fluttertoast.showToast(msg: "No contact chosen. Vent cancelled.");
        return;
      }
    }
    if (chosenHash == null) {
      Fluttertoast.showToast(msg: "Some error occurred. Vent cancelled.");
      return;
    }
    send(processData, chosenHash);
  }
}
