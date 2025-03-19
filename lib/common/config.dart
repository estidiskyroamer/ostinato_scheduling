import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ostinato/common/components/theme_extension.dart';

class Config {
  final storage = const FlutterSecureStorage();

  //default settings value
  int courseLengthDef = 30;
  int repeatDef = 4;

  LoadingIndicator loadingIndicator = LoadingIndicator(
    indicatorType: Indicator.ballPulseSync,
    colors: [
      Colors.grey.withAlpha(50),
      Colors.grey.withAlpha(125),
      Colors.grey
    ],
  );
}

EdgeInsetsGeometry padding16 = const EdgeInsets.all(16);
EdgeInsetsGeometry padding12 = const EdgeInsets.all(12);
EdgeInsetsGeometry padding8 = const EdgeInsets.all(8);
EdgeInsetsGeometry padding4 = const EdgeInsets.all(4);

ThemeData lightTheme = ThemeData(
  fontFamily: 'Garamond',
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black, height: 1.0),
    titleMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black, height: 1.0),
    titleSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black, height: 1.0),
    bodyLarge: TextStyle(fontSize: 26, color: Colors.black),
    bodyMedium: TextStyle(fontSize: 18, color: Colors.black),
    bodySmall: TextStyle(fontSize: 10, color: Colors.black),
    displayLarge: TextStyle(fontSize: 26, fontStyle: FontStyle.italic, color: Colors.black),
    displayMedium: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: Colors.black),
    displaySmall: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black),
    labelLarge: TextStyle(fontFamily: "Montserrat", fontSize: 16, color: Colors.black),
    labelMedium: TextStyle(fontFamily: "Montserrat", fontSize: 14, color: Colors.black),
    labelSmall: TextStyle(fontFamily: "Montserrat", fontSize: 12, color: Colors.black),
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelTextStyle: WidgetStateProperty.all(const TextStyle(fontFamily: "Montserrat", fontSize: 12, color: Colors.black)),
  ),
  scaffoldBackgroundColor: Colors.white,
  dialogBackgroundColor: Colors.grey[300],
  tabBarTheme: const TabBarTheme(
    indicatorColor: Colors.black,
    labelColor: Colors.black,
    unselectedLabelColor: Color.fromARGB(255, 95, 95, 95),
  ),
  bottomSheetTheme: BottomSheetThemeData(elevation: 0, backgroundColor: Colors.grey[300]),
  appBarTheme: const AppBarTheme(
    scrolledUnderElevation: 0,
    elevation: 0,
    backgroundColor: Colors.white,
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  extensions: <ThemeExtension<dynamic>>[
       OstinatoThemeExtension(
        headerBackgroundColor: Color.fromARGB(255, 50, 50, 50),
        headerForegroundColor: Colors.white,
        rowIconColor: Colors.grey[400]!,
        inputHintColor: Colors.black38,
        textColor: Colors.black,
        borderColor: Colors.black,
    )
  ]
);

ThemeData darkTheme = ThemeData(
  fontFamily: 'Garamond',
  brightness: Brightness.dark,
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, height: 1.0),
    titleMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, height: 1.0),
    titleSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, height: 1.0),
    bodyLarge: TextStyle(fontSize: 26, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 18, color: Colors.white),
    bodySmall: TextStyle(fontSize: 10, color: Colors.white),
    displayLarge: TextStyle(fontSize: 26, fontStyle: FontStyle.italic, color: Colors.white),
    displayMedium: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: Colors.white),
    displaySmall: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white),
    labelLarge: TextStyle(fontFamily: "Montserrat", fontSize: 16, color: Colors.white),
    labelMedium: TextStyle(fontFamily: "Montserrat", fontSize: 14, color: Colors.white),
    labelSmall: TextStyle(fontFamily: "Montserrat", fontSize: 12, color: Colors.white),
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelTextStyle: WidgetStateProperty.all(const TextStyle(fontFamily: "Montserrat", fontSize: 12, color: Colors.white)),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 25, 25, 25),
  dialogBackgroundColor: Colors.grey[900],
  tabBarTheme: const TabBarTheme(
    indicatorColor: Colors.white,
    labelColor: Colors.white,
    unselectedLabelColor: Colors.grey,
  ),
  bottomSheetTheme: BottomSheetThemeData(elevation: 0, backgroundColor: Colors.grey[900]),
  appBarTheme: const AppBarTheme(
    scrolledUnderElevation: 0,
    elevation: 0,
    backgroundColor: Colors.black,
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  extensions: const <ThemeExtension<dynamic>>[
       OstinatoThemeExtension(
        headerBackgroundColor: Color.fromARGB(255, 15, 15, 15),
        headerForegroundColor: Colors.white60,
        rowIconColor: Color.fromARGB(255, 45, 45, 45),
        inputHintColor: Colors.white30,
        textColor: Colors.white,
        borderColor: Color.fromARGB(255, 70, 70, 70)
    )
  ]
);


extension StringCapitalization on String {
  /// Capitalizes the first letter of a single word or sentence.
  String capitalizeFirst() {
    if (isEmpty) return '';
    return this[0].toUpperCase() + substring(1);
  }

  /// Capitalizes the first letter of each word in a sentence.
  String capitalizeEachWord() {
    if (isEmpty) return '';
    return split(' ')
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : word)
        .join(' ');
  }
}

class Settings {
  static Future<Map<String, String>> getSettings() async {
    String? courseLengthString =
        await Config().storage.read(key: 'course_length');
    String? repeatString = await Config().storage.read(key: 'repeat');

    return {
      'courseLength': courseLengthString ?? Config().courseLengthDef.toString(),
      'repeat': repeatString ?? Config().repeatDef.toString(),
    };
  }
}
