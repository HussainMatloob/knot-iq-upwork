import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:knot_iq/controllers/home_controller.dart' show HomeController;
import 'package:knot_iq/controllers/notifications_controller.dart';
import 'package:knot_iq/l10n/app_localizations.dart';
import 'package:knot_iq/presentation/splash_screen.dart';
import 'package:knot_iq/services/awesome_notification_service.dart';

import 'package:knot_iq/utils/colors.dart';

late Size mq;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBzWexqrBTU3knktM5QiUxeDZcqikhEsQk",
      appId: "1:970326125016:android:7f328a8325b5f3b70c2aad",
      messagingSenderId: "970326125016",
      projectId: "wedplan360-c96ef",
    ),
  );

  NotificationsController notificationController = Get.put(
    NotificationsController(),
    permanent: true,
  );

  await notificationController.getAccessToken();
  await FirebaseMessaging.instance.requestPermission();
  await AwesomeNotificationService().init();

  if (Platform.isIOS) {
    notificationController.requestIOSPermissions();
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  notificationController.showForegroundNotification();

  Get.put(HomeController()); // register controller
  runApp(const MyApp());
}

//show notification when app background or terminate
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // print("======__----------- Notification");
  // if (message.notification?.title != null) {}
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return GetMaterialApp(
          locale: controller.locale, // dynamic locale

          supportedLocales: const [
            Locale('en'),
            Locale('fr'),
            Locale('ar'),
            Locale('es'),
            Locale('it'),
          ],

          localizationsDelegates: const [
            AppLocalizations.delegate, // REQUIRED
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          debugShowCheckedModeBanner: false,
          title: 'WedPlan 360',
          theme: ThemeData(
            fontFamily: "Aptos",
            colorScheme: ColorScheme.fromSeed(
              seedColor: Appcolors.primaryColor,
            ),
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
