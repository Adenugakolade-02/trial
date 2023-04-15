import 'package:firebase_messaging/firebase_messaging.dart';

void setupLocalNotification() async {
  // Request for permission for IOS.
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}