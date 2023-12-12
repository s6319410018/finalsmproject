import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smartwater/services/call_api_firebase.dart';
import 'package:smartwater/views/splash.dart';

final FlutterLocalNotificationsPlugin flutterLocaPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  /* WidgetsFlutterBinding.ensureInitialized();
  await initservice();*/
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: "channelKey",
            channelName: "channelName",
            channelDescription: "channelDescription")
      ],
      debug: true);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashUI(),
  ));
}

/*Future<void> initservice() async {
  var service = FlutterBackgroundService();
  if (Platform.isIOS) {
    await flutterLocaPlugin.initialize(
        const InitializationSettings(iOS: DarwinInitializationSettings()));
  }
  await flutterLocaPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(AndroidNotificationChannel(
          "coding is life forround", "coding is life forround service",
          description: "This is chanal des...", importance: Importance.high));
  await service.configure(
      iosConfiguration:
          IosConfiguration(onBackground: iosBacground, onForeground: onStart),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: true,
          isForegroundMode: true,
          notificationChannelId: "coding is life",
          initialNotificationTitle: "coding is life",
          initialNotificationContent: "Awsom Content",
          foregroundServiceNotificationId: 90));
  service.startService();
}

@pragma("vm:entry-point")
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();
  service.on("setAsForeground").listen((event) {
    print("foreground ================");
  });
  service.on("setAsBackground").listen((event) {
    print("background ================");
  });
  service.on("stopService").listen((event) {
    service.stopSelf();
  });

  Timer.periodic(Duration(seconds: 2), (Timer timer) {
    flutterLocaPlugin.show(
        90,
        "Cool Service",
        "Awsome${DateTime.now()}",
        NotificationDetails(
            android: AndroidNotificationDetails(
                "coding is life", "coding is life service",
                icon: "app_icon", ongoing: true)));
  });
}

@pragma("vm:entry-point")
Future<bool> iosBacground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}
*/