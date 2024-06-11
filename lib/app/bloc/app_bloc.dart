import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vent/app/app.dart';
import 'package:vent/src/repository/notificationService.dart';
import 'package:vent/src/src.dart';
import 'package:fluttertoast/fluttertoast.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthenticationService authService, required NotificationService notificationService})
      : _authService = authService,
        _notificationService = notificationService,
        super(AppState.initial()) {
    on<AppInitial>(_onInit);
    on<_AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authService.user.listen(
          (user) {
        add(_AppUserChanged(user));
      },
    );
  }

  final AuthenticationService _authService;
  final NotificationService _notificationService;
  late final StreamSubscription<UserModel> _userSubscription;

  Future<void> onAppLifecycleStateChange(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await _notificationService.cancelAll();
    }
  }

  void _onInit(AppInitial event, Emitter<AppState> emit) async {
    final userModel = await _authService.currentUser;
    if (userModel.isEmpty) {
      ventRouter.go("/login");
    }
    emit(
      userModel.isNotEmpty
          ? AppState.authenticated(userModel)
          : const AppState.unauthenticated(),
    );
  }

  void _onUserChanged(_AppUserChanged event, Emitter<AppState> emit) {
    if (event.userModel.isEmpty) {
      ventRouter.go("/login");
    }
    emit(
      event.userModel.isNotEmpty
          ? AppState.authenticated(event.userModel)
          : const AppState.unauthenticated(),
    );
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    ventRouter.go("/login");
    unawaited(_authService.logOut((exception) {
      print("Logout failed with exception: $exception");
      Fluttertoast.showToast(msg: "Logout failed");
    }));
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
