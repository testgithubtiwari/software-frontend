import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  Future initialize() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        print('Notification title: ${message.notification?.title}');
        print('Notification body: ${message.notification?.body}');
      }
    });

    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  }
}

Future<void> backgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}
