
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/app/bloc/app_bloc.dart';
import 'package:vent/app/route/route.dart';
import 'package:vent/src/config.dart';
import 'package:vent/src/repository/authService.dart';

class App extends StatelessWidget {
  App({
    required AuthenticationService authService,
    super.key,
  }) : _authService = authService;

  final AuthenticationService _authService;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authService,
      child: BlocProvider(
        create: (_) => AppBloc(
          authService: _authService,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    Map<Brightness, ThemeData> themes = themeBuilder();
    return MaterialApp.router(
      title: 'Vent',
      routerConfig: ventRouter,
      theme: themes[Brightness.light],
      darkTheme: themes[Brightness.dark],
      debugShowCheckedModeBanner: false,
    );
  }
}