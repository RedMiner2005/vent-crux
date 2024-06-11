import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:vent/app/app.dart';
import 'package:vent/firebase_options.dart';
import 'package:vent/home/cubit/home_cubit.dart';
import 'package:vent/src/repository/repository.dart';

Future<void> main({bool? isFromNotification}) async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final cacheManager = DefaultCacheManager();
  final dataService = DataService(cache: cacheManager);
  final voiceService = VoiceService();
  final backendService = BackendService();
  final contactService = ContactService(dataService: dataService);
  final notificationService = NotificationService(dataService: dataService);
  final authService = AuthenticationService(dataService: dataService, initialHomeStatus: (isFromNotification == true) ? HomeStatus.notifications : HomeStatus.home);
  final app = App(
    authService: authService,
    notificationService: notificationService,
    backendService: backendService,
    contactService: contactService,
    voiceService: voiceService,
    dataService: dataService,
  );

  notificationService.init(
    onForegroundTap: (message) async {
      ventRouter.clearStackAndPush("/", extra: HomeStatus.notifications);
    }
  );
  await authService.user.first;

  runApp(app);
}
