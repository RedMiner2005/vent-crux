import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vent/login/login.dart';
import 'package:vent/src/repository/authService.dart';

class PhoneCodeView extends StatelessWidget {
  const PhoneCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("Enter the code"),
          ElevatedButton(
              onPressed: () {
                context.read<AuthenticationService>().userObject = context.read<AuthenticationService>().userObject.copyWith(name: "Test");
                context.go("/");
              },
              child: Text("Next")
          )
        ],
      ),
    );
  }
}
