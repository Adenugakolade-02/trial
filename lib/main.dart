import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:web_admin/constants/web_routes.dart';
import 'package:web_admin/notification.dart';
import 'package:web_admin/router.dart';
import 'package:web_admin/service_locator.dart';
import 'package:web_admin/services/navigation_service.dart';
import 'package:web_admin/services/snackbar_service.dart';

import 'constants/app_theme.dart';

void main() async {
  // Initialize Firebase
  await Firebase.initializeApp(options: const FirebaseOptions(
    apiKey: 'AIzaSyCJtcoAg-Na9craJY8PspDFXqRcsgAC1Uc',
    appId: '1:477826821886:web:8e3644aac45443a16b7faf',
    messagingSenderId: '477826821886',
    projectId: 'trybagc',
  ));

  // Initialize Service Locator
  setupLocator();

  // Initialize local notification
  setupLocalNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web Admin',
      theme: AppTheme.materialTheme(context),
      initialRoute: WebRoute.startup,
      onGenerateRoute: AppRouter.generateRoute,
      debugShowCheckedModeBanner: false,
      navigatorKey: serviceLocator<NavigatorService>().navigatorKey,
      builder: (context, child) => SafeArea(
        child: Scaffold(
          key: serviceLocator<SnackBarService>().snackbarKey,
          body: child,
        ),
      ),
    );
  }
}
