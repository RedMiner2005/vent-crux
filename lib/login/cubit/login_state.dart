part of 'login_cubit.dart';

enum LoginStatus {
  loading,
  phone,
  code
}

final class LoginState extends Equatable {
  const LoginState._({required this.status});

  const LoginState.loading() : this._(status: LoginStatus.loading);
  const LoginState.phone() : this._(status: LoginStatus.phone);
  const LoginState.code() : this._(status: LoginStatus.code);


  @override
  List<Object?> get props => [status];

  final LoginStatus status;

  LoginState copyWith({LoginStatus? status}) {
    return LoginState._(status: status ?? this.status);
  }
}
