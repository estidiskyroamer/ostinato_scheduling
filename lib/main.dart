import 'package:flutter/material.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/navigation.dart';
import 'package:toastification/toastification.dart';
//import 'package:wheretowatch/common/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Config().storage.read(key: 'course_length').then((value) {
    if (value == null) {
      Config().storage.write(
          key: 'course_length', value: Config().courseLengthDef.toString());
    }
  });
  Config().storage.read(key: 'repeat').then((value) {
    if (value == null) {
      Config()
          .storage
          .write(key: 'repeat', value: Config().repeatDef.toString());
    }
  });
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'Ostinato',
        theme: lightTheme, // Light Mode Theme
        darkTheme: darkTheme, // Dark Mode Theme
        themeMode: ThemeMode.system, // Follows system dark mode setting
        navigatorKey: navigatorKey,
        home: const NavigationPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
