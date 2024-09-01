import 'package:flutter/material.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/navigation.dart';
import 'package:toastification/toastification.dart';
//import 'package:wheretowatch/common/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Prefs().init();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /* if (!Prefs().preferences.containsKey("region")) {
      Prefs().preferences.setString("region", "US");
      Prefs().preferences.setString("region_name", "United States of America");
    } */
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'Ostinato',
        theme: ostinatoTheme,
        navigatorKey: navigatorKey,
        home: const NavigationPage(),
      ),
    );
  }
}
