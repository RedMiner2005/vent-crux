import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vent/app/widgets/loading.dart';
import 'package:vent/login/cubit/login_cubit.dart';
import 'package:vent/login/login.dart';
import 'package:vent/login/widgets/widgets.dart';
import 'package:vent/src/repository/authService.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(authService: context.read<AuthenticationService>()),
      child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            LoginCubit loginCubit = context.read<LoginCubit>();
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(),
              body: (state.status == LoginStatus.loading) ? LoadingWidget() : SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                          child: ColorText(
                            "Vent",
                            style: TextStyle(
                              fontSize: 72.0,
                              fontFamily: 'Redressed'
                            ),
                          )
                      ),
                      Text("Login", style: TextStyle(fontSize: 20.0),).animate()
                          .fade(delay: 300.ms, duration: 700.ms),
                      SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: (state.status == LoginStatus.phone) ? PhoneLoginView(loginCubit: loginCubit,) : PhoneCodeView(loginCubit: loginCubit,),
                          ),
                        ).animate()
                            .fade(delay: 900.ms, duration: 200.ms),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
    );
  }
}
