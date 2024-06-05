import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vent/login/login.dart';
import 'package:vent/login/views/loginView.dart';
import 'package:vent/login/widgets/loginTextFields.dart';
import 'package:vent/login/widgets/widgets.dart';
import 'package:vent/src/config.dart';

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
            child: Text({
              PhoneValidStatus.initial: "Enter your phone number",
              PhoneValidStatus.valid: "",
              PhoneValidStatus.invalid: "Invalid phone number"
            }[loginCubit.state.phoneValidStatus]!,
              key: ValueKey<PhoneValidStatus>(loginCubit.state.phoneValidStatus),
            ),
          ),
        ),
        SizedBox(height: 10,),
        FloatingActionButton.extended(
          onPressed: (isValid) ? loginCubit.phoneNumberSubmit : null,
          backgroundColor: (isValid) ? null : Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
          foregroundColor: (isValid) ? null : Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
          icon: Text("Next"),
          label: Icon(Icons.navigate_next_rounded),
          elevation: 4.0,
          disabledElevation: 0.0,
        )
      ],
    );
  }
}
