import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/home/cubit/home_cubit.dart';
import 'package:vent/src/repository/authService.dart';

class HomeView extends StatelessWidget {
  const HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(authService: context.read<AuthenticationService>()),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text("Home Page"),),
            body: Container(),
          );
        },
      ),
    );
  }
}
