import 'package:flutter/material.dart';
import 'package:vent/login/login.dart';
import 'package:vent/login/widgets/loginTextFields.dart';
import 'package:vent/login/widgets/widgets.dart';

class PhoneLoginView extends StatelessWidget {
  const PhoneLoginView({required this.loginCubit});

  final LoginCubit loginCubit;

  @override
  Widget build(BuildContext context) {
    bool isValid = loginCubit.state.phoneValidStatus == PhoneValidStatus.valid;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoginField(onChanged: loginCubit.validatePhoneText, fieldType: LoginFieldType.phone),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: StatusText(
            texts: {
              PhoneValidStatus.initial: "Enter your phone number",
              PhoneValidStatus.valid: "",
              PhoneValidStatus.invalid: "Invalid phone number"
            },
            current: loginCubit.state.phoneValidStatus,
          ),
        ),
        SizedBox(height: 10,),
        LoginSubmitButton(loginCubit: loginCubit,),
      ],
    );
  }
}
