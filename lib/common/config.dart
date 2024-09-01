import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Config {
  final storage = const FlutterSecureStorage();
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

EdgeInsetsGeometry padding8 = const EdgeInsets.all(8);

EdgeInsetsGeometry padding4 = const EdgeInsets.all(4);

ThemeData ostinatoTheme = ThemeData(
    fontFamily: 'Garamond',
    colorSchemeSeed: Colors.white,
    textTheme: TextTheme(
      titleLarge: const TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1.0,
      ),
      titleMedium: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1.0,
      ),
      titleSmall: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1.0,
      ),
      bodyLarge: const TextStyle(
        fontSize: 24,
        color: Colors.black,
      ),
      bodyMedium: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      bodySmall: const TextStyle(
        fontSize: 8,
        color: Colors.black,
      ),
      displayLarge: const TextStyle(
        fontSize: 26,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
      displayMedium: const TextStyle(
        fontSize: 18,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
      displaySmall: const TextStyle(
        fontSize: 10,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
      labelLarge: TextStyle(
          fontFamily: "Montserrat", fontSize: 18, color: Colors.grey[700]),
      labelMedium: TextStyle(
          fontFamily: "Montserrat", fontSize: 14, color: Colors.grey[700]),
      labelSmall: TextStyle(
          fontFamily: "Montserrat", fontSize: 10, color: Colors.grey[700]),
    ),
    navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: MaterialStateProperty.all(TextStyle(
            fontFamily: "Montserrat", fontSize: 10, color: Colors.grey[700]))));
