import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

void main() {
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
    home: MyWidget(),
  ));
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );
    super.initState();
  }

  triggerNotification_On_Ai() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      channelKey: "channelKey",
      title: "คำเตือน",
      body: 'ขณะนี้น้ำถูกเปิดอัตโนมัติ',
    ));
  }

  triggerNotification_Off_Ai() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: "channelKey",
            title: "คำเตือน",
            body: 'ขณะนี้น้ำถูกปิดอัตโนมัติ',
            backgroundColor: Colors.blue.withOpacity(0.3)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                triggerNotification_On_Ai();
              },
              child: Text("data")),
          ElevatedButton(
              onPressed: () {
                triggerNotification_Off_Ai();
              },
              child: Text("data")),
        ],
      ),
    );
  }
}
