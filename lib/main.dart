import 'package:DesignCredit/firebase_options.dart';
import 'package:DesignCredit/pushnotificationservice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:DesignCredit/screens/auth/loginscreen.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.grey,
    statusBarColor: Colors.black,
  ));
  // FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final PushNotificationService _notificationService =
  //     PushNotificationService();
  // @override
  // void initState() {
  //   print('Hello !');
  //   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  //   _firebaseMessaging.getToken().then((token) {
  //     print("token is $token");
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // _notificationService.initialize();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Design Credit',
      home: LoginScreen(),
    );
  }
}
