import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vent/app/app.dart';
import 'package:vent/src/config.dart';
import 'package:vent/src/repository/authService.dart';
import 'package:vent/src/repository/repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required AuthenticationService authService}) : _authService = authService, super(LoginState.phone());

  final AuthenticationService _authService;
  String _phone = "";
  String _code = "";
  String _verificationId = "";
  late Function(String code, String verificationId, Function(dynamic exception) codeVerificationFailed) authCodeSubmit;

  void phoneNumberSubmit(Function goHome) async {
    emit(state.copyWith(isLoading: true));
    authCodeSubmit = await _authService.logInWithPhone(
        (await ContactService.get_e164(_phone)) ?? _phone,
      () {
        emit(state.copyWith(codeValidStatus: CodeValidStatus.verified, isLoading: false));
        log("Successful login");
        ventRouter.go("/");
      },
      (exception) {
        if (exception is ConnectionError) {
          Fluttertoast.showToast(msg: "Check your connection");
        } else {
          Fluttertoast.showToast(msg: "Could not login");
        }
        log("Phone login failed: $exception");
        emit(LoginState.phone());
      },
      (phone, verificationId, forceResendingToken) {
        _verificationId = verificationId;
        Fluttertoast.showToast(msg: "Code sent");
        emit(LoginState.code());
      },
      (verificationId) {
        _verificationId = verificationId;
      }
    );
  }

  void codeSubmit() {
    emit(state.copyWith(isLoading: true));
    authCodeSubmit(_code, _verificationId, (exception) {
      log("Code verification failed: $exception");
      emit(state.copyWith(codeValidStatus: CodeValidStatus.invalid));
      Fluttertoast.showToast(msg: "Code verification failed");
    });
  }

  void validatePhoneText(String phone) {
    if (phone == "") {
      emit(state.copyWith(phoneValidStatus: PhoneValidStatus.initial));
    } else if (VentConfig.phoneRegex.hasMatch(phone)) {
      _phone = phone;
      emit(state.copyWith(phoneValidStatus: PhoneValidStatus.valid));
    } else {
      emit(state.copyWith(phoneValidStatus: PhoneValidStatus.invalid));
    }
  }

  void validateCodeText(String code) {
    if (state.codeValidStatus == CodeValidStatus.invalid) {
      emit(state.copyWith(codeValidStatus: CodeValidStatus.valid));
    }
    if (code == "" || !VentConfig.codeRegex.hasMatch(code)) {
      emit(state.copyWith(codeValidStatus: CodeValidStatus.initial));
    } else {
      _code = code;
      emit(state.copyWith(codeValidStatus: CodeValidStatus.valid));
    }
  }
}
