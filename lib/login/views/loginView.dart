import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/app/widgets/loading.dart';
import 'package:vent/login/cubit/login_cubit.dart';
import 'package:vent/login/login.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text("Login Page"),),
            body: (state.status == LoginStatus.loading) ? LoadingWidget()
                      : ((state.status == LoginStatus.phone) ? PhoneLoginView() : PhoneCodeView()),
          );
        },
      ),
    );;
  }
}
