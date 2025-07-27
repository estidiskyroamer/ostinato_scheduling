import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ostinato/common/components/theme_extension.dart';

class Config {
  final storage = const FlutterSecureStorage();

  //default settings value
  int courseLengthDef = 30;
  int repeatDef = 4;

  LoadingIndicator loadingIndicator = LoadingIndicator(
    indicatorType: Indicator.ballPulseSync,
    colors: [Colors.grey.withAlpha(50), Colors.grey.withAlpha(125), Colors.grey],
  );
}

EdgeInsetsGeometry padding16 = const EdgeInsets.all(16);
EdgeInsetsGeometry padding12 = const EdgeInsets.all(12);
EdgeInsetsGeometry padding8 = const EdgeInsets.all(8);
EdgeInsetsGeometry padding4 = const EdgeInsets.all(4);

ThemeData lightTheme = ThemeData(
    fontFamily: 'Alegreya',
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
    scaffoldBackgroundColor: Colors.white,
    tabBarTheme: TabBarThemeData(
      indicatorColor: Colors.black,
      labelColor: Colors.black,
      unselectedLabelColor: HexColor("#5f5f5f"),
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
        headerBackgroundColor: HexColor("#dedede"),
        headerForegroundColor: HexColor("#323232"),
        rowIconColor: Colors.grey[400]!,
        inputHintColor: Colors.black38,
        textColor: Colors.black,
        borderColor: Colors.black,
        buttonBackgroundColor: Colors.black,
        buttonForegroundColor: Colors.white,
        separatorColor: Colors.black38,
        scheduleHighlightColor: HexColor("#FFF0D4"),
        navBarColor: HexColor("#dedede"),
        navBarSelectedItemColor: Colors.black,
        navBarUnselectedItemColor: HexColor("#4c4c4c"),
        dangerColor: Colors.red,
      )
    ],
    dialogTheme: DialogThemeData(backgroundColor: Colors.grey[300]));

ThemeData darkTheme = ThemeData(
    fontFamily: 'Alegreya',
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
    scaffoldBackgroundColor: HexColor("#0a0a0a"),
    tabBarTheme: const TabBarThemeData(
      indicatorColor: Colors.white,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey,
    ),
    bottomSheetTheme: BottomSheetThemeData(elevation: 0, backgroundColor: Colors.grey[900]),
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
      elevation: 0,
      backgroundColor: HexColor("#0a0a0a"),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    extensions: <ThemeExtension<dynamic>>[
      OstinatoThemeExtension(
        headerBackgroundColor: HexColor("#1e1e1e"),
        headerForegroundColor: Colors.white60,
        rowIconColor: HexColor("#2d2d2d"),
        inputHintColor: Colors.white30,
        textColor: Colors.white,
        borderColor: Colors.white,
        buttonBackgroundColor: Colors.white,
        buttonForegroundColor: Colors.black,
        separatorColor: Colors.white12,
        scheduleHighlightColor: HexColor("#453d2d"),
        navBarColor: Colors.black,
        navBarSelectedItemColor: Colors.white,
        navBarUnselectedItemColor: HexColor("acacac"),
        dangerColor: HexColor("#b01b10"),
      )
    ],
    dialogTheme: DialogThemeData(backgroundColor: Colors.grey[900]));

extension StringCapitalization on String {
  /// Capitalizes the first letter of a single word or sentence.
  String capitalizeFirst() {
    if (isEmpty) return '';
    return this[0].toUpperCase() + substring(1);
  }

  /// Capitalizes the first letter of each word in a sentence.
  String capitalizeEachWord() {
    if (isEmpty) return '';
    return split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : word).join(' ');
  }
}

class LocalSettings {
  static Future<Map<String, String>> getSettings() async {
    String? courseLengthString = await Config().storage.read(key: 'course_length');
    String? repeatString = await Config().storage.read(key: 'repeat');

    return {
      'courseLength': courseLengthString ?? Config().courseLengthDef.toString(),
      'repeat': repeatString ?? Config().repeatDef.toString(),
    };
  }
}
