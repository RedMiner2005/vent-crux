import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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

  Future<void> send() async {
    final result = await _backendService.process(_controller.text);
    log(result.toString());
    log((await _contactService.findMatches(result["contact"])).toString());
    // Future.delayed(const Duration(seconds: 2), () => _backendService.send("+911234512345", result["toSend"]));
  }
}
