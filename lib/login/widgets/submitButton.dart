import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:vent/app/app.dart';
import 'package:vent/login/cubit/login_cubit.dart';

class LoginSubmitButton extends StatelessWidget {
  const LoginSubmitButton({super.key, required this.loginCubit});

  final LoginCubit loginCubit;

  @override
  Widget build(BuildContext context) {
    late IconData? icon;
    late String text;
    late bool isEnabled;
    late dynamic onPressed;
    if(loginCubit.state.isLoading || loginCubit.state.status == LoginStatus.loading) {
      isEnabled = false;
      text = "Loading";
      icon = null;
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
      icon = null;
      onPressed = () {};
    }
    Widget iconWidget = (icon == null) ? SpinKitPulse(
      size: 20.0,
      color: (Theme.of(context).brightness == Brightness.light) ? Colors.black38 : Colors.white38,
      key: ValueKey<IconData?>(icon),
    ) : Icon(icon);
    return FloatingActionButton.extended(
      onPressed: (isEnabled) ? onPressed : null,
      backgroundColor: (isEnabled) ? null : Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
      foregroundColor: (isEnabled) ? null : Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
      icon: Text(text, key: ValueKey<String>(text),),
      label: iconWidget,
      elevation: 4.0,
      disabledElevation: 0.0,
    );
  }
}
