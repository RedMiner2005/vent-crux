import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vent/app/app.dart';
import 'package:vent/login/cubit/login_cubit.dart';

class LoginSubmitButton extends StatelessWidget {
  const LoginSubmitButton({super.key, required this.loginCubit});

  final LoginCubit loginCubit;

  @override
  Widget build(BuildContext context) {
    late IconData icon;
    late String text;
    late bool isEnabled;
    late dynamic onPressed;
    if(loginCubit.state.isLoading || loginCubit.state.status == LoginStatus.loading) {
      isEnabled = false;
      text = "Loading";
      icon = Icons.access_time_rounded;
      onPressed = () {};
    } else if (loginCubit.state.status == LoginStatus.phone) {
      isEnabled = loginCubit.state.phoneValidStatus == PhoneValidStatus.valid;
      text = "Next";
      icon = Icons.navigate_next_rounded;
      onPressed = () => loginCubit.phoneNumberSubmit(() => GoRouter.of(context).go('/'));
    } else if (loginCubit.state.status == LoginStatus.code) {
      if(loginCubit.state.codeValidStatus == CodeValidStatus.verified) {
        isEnabled = true;
        text = "Continue";
        icon = Icons.navigate_next_rounded;
        onPressed = () {
          ventRouter.go("/");
        };
      } else {
        isEnabled = loginCubit.state.codeValidStatus == CodeValidStatus.valid;
        text = "Verify";
        icon = Icons.done_rounded;
        onPressed = () {
          loginCubit.codeSubmit();
        };
      }
    } else {
      isEnabled = false;
      text = "Loading";
      icon = Icons.access_time_rounded;
      onPressed = () {};
    }
    return FloatingActionButton.extended(
      onPressed: (isEnabled) ? onPressed : null,
      backgroundColor: (isEnabled) ? null : Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
      foregroundColor: (isEnabled) ? null : Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
      icon: Text(text),
      label: Icon(icon),
      elevation: 4.0,
      disabledElevation: 0.0,
    );
  }
}
