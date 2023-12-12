import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/*class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final FCMToken = await _firebaseMessaging.getToken();
    print('Token: $FCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}
*/

class FirebaseAPI {
  final _firebaseMassaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMassaging.requestPermission();
    final fCMtoken = await _firebaseMassaging.getToken();
    print('Tokencccccccccccc:+ $fCMtoken');
  }
}
