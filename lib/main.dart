import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:vent/app/app.dart';
import 'package:vent/firebase_options.dart';
import 'package:vent/src/repository/authService.dart';
import 'package:vent/src/repository/dataService.dart';
import 'package:vent/src/repository/notificationService.dart';

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

  final CacheManager cacheManager = DefaultCacheManager();
  final DataService dataService = DataService(cache: cacheManager);
  final notificationService = NotificationService(dataService);
  final authService = AuthenticationService(dataService: dataService);
  final app = App(authService: authService,);
  notificationService.init((message) {
    runApp(app);
  });
  await authService.user.first;

  runApp(app);
}
