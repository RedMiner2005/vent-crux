
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/app/bloc/app_bloc.dart';
import 'package:vent/app/route/route.dart';
import 'package:vent/src/config.dart';
import 'package:vent/src/repository/repository.dart';

class App extends StatelessWidget {
  App({
    required AuthenticationService authService,
    required NotificationService notificationService,
    required BackendService backendService,
    required DataService dataService,
    required VoiceService voiceService,
    super.key,
  }) : _authService = authService,
        _dataService = dataService,
        _backendService = backendService,
        _voiceService = voiceService,
        _notificationService = notificationService;

  final AuthenticationService _authService;
  final NotificationService _notificationService;
  final BackendService _backendService;
  final DataService _dataService;
  final VoiceService _voiceService;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authService),
        RepositoryProvider.value(value: _notificationService),
        RepositoryProvider.value(value: _backendService),
        RepositoryProvider.value(value: _dataService),
        RepositoryProvider.value(value: _voiceService),
      ],
      child: BlocProvider(
        create: (_) => AppBloc(
          authService: _authService,
        ),
        child: const AppView(),
      )
    );
    // return RepositoryProvider.value(
    //   value: _authService,
    //   child: BlocProvider(
    //     create: (_) => AppBloc(
    //       authService: _authService,
    //     ),
    //     child: const AppView(),
    //   ),
    // );
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