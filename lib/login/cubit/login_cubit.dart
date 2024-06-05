import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vent/src/repository/authService.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required AuthenticationService authService}) : _authService = authService, super(LoginState.phone());

  final AuthenticationService _authService;
  String _phone = "";

  void phoneNumberSubmit() {
    // _authService.logInWithPhone(
    //   _phone,
    //   () {},
    //   (exception) => null,
    //   (phone, verificationId, forceResendingToken) => null,
    //   (verificationId) => null
    // );
    emit(LoginState.code());
  }

  void validatePhoneText(String phone) {
    RegExp phoneRegex = RegExp(r'^(?:[+0]9)?[0-9]{10}$');
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
    if (code == "") {
      emit(state.copyWith(codeValidStatus: CodeValidStatus.initial));
    } else {
      emit(state.copyWith(codeValidStatus: CodeValidStatus.valid));
    }
  }
}
