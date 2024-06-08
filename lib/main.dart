import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:vent/app/app.dart';
import 'package:vent/firebase_options.dart';
import 'package:vent/src/repository/repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final cacheManager = DefaultCacheManager();
  final dataService = DataService(cache: cacheManager);
  final voiceService = VoiceService();
  final backendService = BackendService();
  final contactService = ContactService(dataService: dataService);
  final notificationService = NotificationService(dataService: dataService);
  final authService = AuthenticationService(dataService: dataService);
  final app = App(
    authService: authService,
    notificationService: notificationService,
    backendService: backendService,
    contactService: contactService,
    voiceService: voiceService,
    dataService: dataService,
  );
  notificationService.init((message) {
    runApp(app);
  });
  await authService.user.first;

  runApp(app);
}
