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
    required ContactService contactService,
    required VoiceService voiceService,
    super.key,
  }) : _authService = authService,
        _dataService = dataService,
        _backendService = backendService,
        _contactService = contactService,
        _voiceService = voiceService,
        _notificationService = notificationService;

  final AuthenticationService _authService;
  final NotificationService _notificationService;
  final BackendService _backendService;
  final ContactService _contactService;
  final DataService _dataService;
  final VoiceService _voiceService;

  @override
  Widget build(BuildContext context) {
    final appBloc = AppBloc(
      authService: _authService,
      notificationService: _notificationService,
    );
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authService),
        RepositoryProvider.value(value: _notificationService),
        RepositoryProvider.value(value: _backendService),
        RepositoryProvider.value(value: _contactService),
        RepositoryProvider.value(value: _dataService),
        RepositoryProvider.value(value: _voiceService),
      ],
      child: BlocProvider(
        create: (_) => appBloc,
        child: AppView(bloc: appBloc,),
      )
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key, required this.bloc});

  final AppBloc bloc;

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> with WidgetsBindingObserver {

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    widget.bloc.onAppLifecycleStateChange(state);
  }

  @override
  Widget build(BuildContext context) {
    Map<Brightness, ThemeData> themes = themeBuilder();
    return MaterialApp.router(
      title: VentConfig.appName,
      routerConfig: ventRouter,
      theme: themes[Brightness.light],
      darkTheme: themes[Brightness.dark],
      debugShowCheckedModeBanner: false,
    );
  }
}