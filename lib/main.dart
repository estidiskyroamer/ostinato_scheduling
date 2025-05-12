import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/login.dart';
import 'package:ostinato/pages/navigation.dart';
import 'package:ostinato/services/auth_service.dart';
import 'package:ostinato/services/settings_service.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  String? token = await AuthService().getToken();
  Widget homePage = const LoginPage();

  if (token != null && token.isNotEmpty) {
    await SettingsService().getSettings();
    homePage = const NavigationPage();
  }

  // Setup background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp(homepage: homePage));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final Widget homepage;
  const MyApp({super.key, required this.homepage});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'Ostinato',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        navigatorKey: navigatorKey,
        home: homepage,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling background message: ${message.messageId}");
}
