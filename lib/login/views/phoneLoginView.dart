import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vent/login/login.dart';

class PhoneLoginView extends StatelessWidget {
  const PhoneLoginView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("Enter your phone number"),
          ElevatedButton(
              onPressed: () => context.read<LoginCubit>().phoneNumberSubmit(""),
              child: Text("Next")
          )
        ],
      ),
    );
  }
}
