import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vent/app/app.dart';
import 'package:vent/src/repository/contactService.dart';
import 'package:vent/src/repository/repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required BackendService backendService, required VoiceService voiceService, required ContactService contactService, required TextEditingController controller}) :
        _backendService = backendService,
        _voiceService = voiceService,
        _contactService = contactService,
        _controller = controller,
        super(HomeState.initial());

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
      log("Processing issue: ${e.toString()}");
      Fluttertoast.showToast(msg: "Could not process your request. Try again.");
      return {};
    }
  }

  Future<void> send(Map<String, dynamic> processData, String chosenHash) async {
    _backendService.send(chosenHash, processData["result"]["toSend"]);
  }
}
