import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwater/models/realtime_model.dart';
import 'package:smartwater/models/user_model.dart';
import 'package:smartwater/services/call_api_home.dart';
import 'package:smartwater/views/splash.dart';
import 'package:workmanager/workmanager.dart';

/*String _email = '';
String _password = '';
List<REALTIME> _realtimeDataList = [];

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await fetchDataAndCheckNotifications();
    return Future.value(true);
  });
}

Future<void> initService() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _email = prefs.getString("email") ?? "";
  _password = prefs.getString("password") ?? "";
  if ((_email == 'null' && _password == 'null') ||
      (_email.isEmpty && _password.isEmpty)) {
    return print('ไม่พบผู้ใช้');
  } else {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    Workmanager().registerPeriodicTask(
      "fetchDataAndCheckNotifications",
      "fetchDataAndCheckNotificationsTask",
      frequency: Duration(minutes: 1), // ด้วยที่ต้องการ
    );
  }
}

Future<void> fetchDataAndCheckNotifications() async {
  try {
    USER userInput = USER(
      userEmail: _email,
      userPassword: _password,
    );
    List<REALTIME> dataUpdateRealtime = await CALLAPIDATAHOME.callApiRealtime(
        BuildContext as BuildContext, userInput);

    // ตรวจสอบการแจ้งเตือนทุก 10 นาที
    checkNotifications(dataUpdateRealtime);
  } catch (e) {
    print("เกิดข้อผิดพลาดในการดึงข้อมูล: $e");
  }
}

void checkNotifications(List<REALTIME> dataUpdateRealtime) {
  if (dataUpdateRealtime.isNotEmpty) {
    for (REALTIME realtimeData in dataUpdateRealtime) {
      if (realtimeData.alert == 1 && realtimeData.realtimeAI == 1) {
        triggerNotificationOnAi();
      }
    }
  }
}

void triggerNotificationOnAi() {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: "channelKey10",
      title: "คำเตือน",
      body: 'มีความผิดปกติในการใช้น้ำเกิดขึ้น',
      backgroundColor: Color.fromARGB(255, 232, 95, 211),
    ),
  );
}*/

void main() async {
  /*WidgetsFlutterBinding.ensureInitialized();
  await initService();*/

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
