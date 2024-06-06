part of 'login_cubit.dart';

enum LoginStatus {
  phone,
  loading,
  code
}

enum PhoneValidStatus {
  initial,
  invalid,
  valid
}

enum CodeValidStatus {
  initial,
  invalid,
  valid
}

final class LoginState extends Equatable {
  const LoginState._({required this.status, required this.phoneValidStatus, required this.codeValidStatus});

  const LoginState.loading() : this._(status: LoginStatus.loading, phoneValidStatus: PhoneValidStatus.initial, codeValidStatus: CodeValidStatus.initial);
  const LoginState.phone({PhoneValidStatus? validStatus}) : this._(status: LoginStatus.phone, phoneValidStatus: validStatus ?? PhoneValidStatus.initial, codeValidStatus: CodeValidStatus.initial);
  const LoginState.code({CodeValidStatus? validStatus}) : this._(status: LoginStatus.code, phoneValidStatus: PhoneValidStatus.valid, codeValidStatus: validStatus ?? CodeValidStatus.initial);


  @override
  List<Object?> get props => [status, phoneValidStatus, codeValidStatus];

  final LoginStatus status;
  final PhoneValidStatus phoneValidStatus;
  final CodeValidStatus codeValidStatus;

  LoginState copyWith({LoginStatus? status, PhoneValidStatus? phoneValidStatus, CodeValidStatus? codeValidStatus}) {
    return LoginState._(
        status: status ?? this.status,
        phoneValidStatus: phoneValidStatus ?? this.phoneValidStatus,
        codeValidStatus: codeValidStatus ?? this.codeValidStatus
    );
  }
}
