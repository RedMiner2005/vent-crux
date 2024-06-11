import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vent/app/app.dart';
import 'package:vent/src/config.dart';
import 'package:vent/src/repository/repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required AuthenticationService authService, required NotificationService notificationService, required BackendService backendService, required VoiceService voiceService, required ContactService contactService, required TextEditingController textController}) :
        _authService = authService,
        _notificationService = notificationService,
        _backendService = backendService,
        _voiceService = voiceService,
        _contactService = contactService,
        textController = textController,
        super(HomeState.defaultState(authService.initialHomeStatus));

  final AuthenticationService _authService;
  final NotificationService _notificationService;
  final BackendService _backendService;
  final VoiceService _voiceService;
  final ContactService _contactService;
  final TextEditingController textController;

  List<Map<String, dynamic>> contactsMatch = [];
  Map<String, dynamic> processData = {};

  void unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  StreamSubscription<ConnectionStatus> listenConnection() {
    return connectedStream.listen(
      (connStatus) {
        if (connStatus == ConnectionStatus.connected) {
          showMessage("Connected.", "Connection stream update: Connected", newState: state.copyWith(connectionStatus: connStatus, persistentMessage: VentConfig.greetingSecondaryText));
        } else {
          showMessage("Check your connection.", "Connection stream update: Disconnected", newState: state.copyWith(connectionStatus: connStatus, persistentMessage: "Connect to a network."));
        }
      }
    );
  }

  Future<Map<String, dynamic>> process() async {
    if (!(await checkConnection())) {
      showMessage("Check your connection.", "Process issue: Connection error");
      return {};
    }
    try {
      final result = await _backendService.process(textController.text)
          .timeout(const Duration(seconds: 20), onTimeout: () {
            showMessage("This took too long. Try again later.", "Process timed out", newState: state.copyWith(isProcessing: false));
            return {"timeout": "timeout"};
          });
      if (result == {})
        throw Exception("Server error");
      if(result.containsKey("timeout"))
        return result;
      print(result.toString());
      contactsMatch = await _contactService.findMatches(result["contact"]);
      return {"result": result, "matches": contactsMatch};
    } on FormatException catch (e) {
      _contactService.sync();
      showMessage("Oh, something wrong on our end. Try clearing cache.", "Agh, that format issue: ${e.toString()}", newState: state.copyWith(isProcessing: false));
      return {};
    } catch (e) {
      showMessage("Something went wrong. Try again.", "Processing issue: ${e.toString()}", newState: state.copyWith(isProcessing: false));
      return {};
    }
  }

  Future<bool> send(String chosenHash) async {
    if (!(await checkConnection())) {
      showMessage("Check your connection.", "Process issue: Connection error");
      return false;
    }
    bool messageShown = false;
    final success = await _backendService.send(chosenHash, processData["result"]["toSend"])
        .timeout(const Duration(seconds: 20), onTimeout: () {
          messageShown = true;
          showMessage("Couldn't send your vent, it took too long.", "Send timed out", newState: state.copyWith(isProcessing: false));
          return false;
        })
        .catchError((e) {
          messageShown = true;
          showMessage("Couldn't send your vent, something went wrong.", "Send issue: ${e.toString()}", newState: state.copyWith(isProcessing: false));
          return false;
        });
    if (success) {
      showMessage("Vent sent!", "${processData["result"]}", newState: state.copyWith(isProcessing: false, isFieldEmpty: true));
    } else if (!messageShown && !success) {
      showMessage("Couldn't send your vent, something went wrong.", "Send issue: Unknown.", newState: state.copyWith(isProcessing: false, isFieldEmpty: true));
    }
    textController.clear();
    return success;
  }

  void showMessage(String userMessage, String logMessage, {bool persistent=false, bool changePersistentMessage=false, HomeState? newState}) {
    print(logMessage);
    if (newState == null)
      newState = state;
    emit(newState.copyWith(isRecording: false, message: userMessage, persistentMessage: (changePersistentMessage) ? userMessage : null));
    if (!persistent)
      Future.delayed(5.seconds, () => emit(state.copyWith(message: state.persistentMessage)));
  }

  void onPageChanged(int newIndex) {
    if(state.status == HomeStatus.notifications && newIndex == 0) {
      _notificationService.cancelAll();
      _authService.clearUnread();
    }
    emit(state.copyWith(status: HomeStatus.values[newIndex], doIntroAnimationHome: false, doIntroAnimationNotifications: false));
  }

  void onHomeFieldChanged(String value) {
    emit(state.copyWith(isFieldEmpty: value == ""));
  }

  void onVoiceButtonPressed() {
    unfocus();
    if(!state.isRecording) {
      _voiceService.start(
            () {},
            (status) => null,
            (append) {
              emit(state.copyWith(isFieldEmpty: false));
              textController.text = append.recognizedWords;
        },
        (e) {
          showMessage("Try speaking louder", "Recording error: ${e.toString()}", newState: state.copyWith(isRecording: false));
        },
      );
      emit(state.copyWith(isRecording: true));
    } else {
      _voiceService.stop();
      emit(state.copyWith(isRecording: false));
    }
  }

  Future<void> onContactClosed(String? chosenHash) async {
    if (chosenHash == null) {
      showMessage("You didn't choose a contact. Vent cancelled.", "No contact chosen", newState: state.copyWith(isProcessing: false));
      return;
    }
    send(chosenHash);
  }

  Future<void> onSendButtonPressed(Function openDialog) async {
    unfocus();
    showMessage("Processing...", "Processing started.", persistent: true, newState: state.copyWith(isProcessing: true));
    if (!(await _contactService.sync())) {
      showMessage("Please enable contacts permission.", "Send cancelled: Contacts denied", newState: state.copyWith(isProcessing: false, persistentMessage: VentConfig.greetingSecondaryText));
      return;
    }
    processData = await process();
    if (processData == {} || !processData.containsKey("result")) {
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
    String? chosenHash;
    print(processData["matches"].toString());
    if(processData["matches"].length == 1) {
      chosenHash = processData["matches"][0]["hash"];
    } else {
      chosenHash = await openDialog();
      return;
    }
    if (chosenHash == null) {
      showMessage("Ah, internal error. Sorry about that", "No return value from contacts dialog", newState: state.copyWith(isProcessing: false, persistentMessage: VentConfig.greetingSecondaryText));
      return;
    }
    send(chosenHash);
  }
}
