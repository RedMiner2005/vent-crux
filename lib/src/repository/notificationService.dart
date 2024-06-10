import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vent/main.dart';
import 'package:vent/src/src.dart';

class NotificationService {
  NotificationService({required DataService? dataService}):
          _dataService = dataService ?? DataService();

  final DataService _dataService;
  late void Function(RemoteMessage) _onMessageTapped;
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'vent_notifications',
    'Vent - by Pratyush',
    importance: Importance.max,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    log("Handling a background message: ${message.messageId}");
    main(isFromNotification: true);
  }

  Future<void> init({required void Function(RemoteMessage) onForegroundTap}) async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    AndroidInitializationSettings('ic_stat_name');
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    _dataService.notificationToken = await FirebaseMessaging.instance.getToken();
    log(_dataService.notificationToken ?? "");
    _onMessageTapped = onForegroundTap;
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: "ic_stat_name",
                priority: Priority.max,
                importance: Importance.max,
                enableVibration: true
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageTapped);
  }
}