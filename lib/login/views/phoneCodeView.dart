import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vent/login/cubit/login_cubit.dart';
import 'package:vent/login/login.dart';
import 'package:vent/src/repository/authService.dart';

import '../widgets/widgets.dart';

class PhoneCodeView extends StatelessWidget {
  const PhoneCodeView({required this.loginCubit});

  final LoginCubit loginCubit;

  @override
  Widget build(BuildContext context) {
    bool isValid = loginCubit.state.codeValidStatus == CodeValidStatus.valid;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoginField(onChanged: loginCubit.validateCodeText, fieldType: LoginFieldType.code),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: StatusText(
            texts: {
              CodeValidStatus.initial: "Enter the code you received",
              CodeValidStatus.valid: "",
              CodeValidStatus.invalid: "Invalid code (or internal error)",
              CodeValidStatus.verified: "Alright, you're good to go!"
            },
            current: loginCubit.state.codeValidStatus,
          ),
        ),
        SizedBox(height: 10,),
        LoginSubmitButton(loginCubit: loginCubit,),
      ],
    );
  }
}
