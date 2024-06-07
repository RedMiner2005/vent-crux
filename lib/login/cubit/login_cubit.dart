import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vent/app/app.dart';
import 'package:vent/src/repository/authService.dart';

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
      _phone,
      () {
        emit(state.copyWith(codeValidStatus: CodeValidStatus.verified));
        log("Successful login");
        ventRouter.go("/");
      },
      (exception) {
        Fluttertoast.showToast(msg: "Could not login");
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
        Fluttertoast.showToast(msg: "Auto verification timed out");
      }
    );
  }

  void codeSubmit() {
    authCodeSubmit(_code, _verificationId, (exception) {
      log("Code verification failed: $exception");
      emit(state.copyWith(codeValidStatus: CodeValidStatus.invalid));
      Fluttertoast.showToast(msg: "Code verification failed");
    });
  }

  void validatePhoneText(String phone) {
    RegExp phoneRegex = RegExp(r'^\+[1-9]{1}[0-9]{3,14}$');
    if (phone == "") {
      emit(state.copyWith(phoneValidStatus: PhoneValidStatus.initial));
    } else if (phoneRegex.hasMatch(phone)) {
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
    if (code == "" || code.length != 6) {
      emit(state.copyWith(codeValidStatus: CodeValidStatus.initial));
    } else {
      _code = code;
      emit(state.copyWith(codeValidStatus: CodeValidStatus.valid));
    }
  }
}
