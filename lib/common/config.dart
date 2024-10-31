import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
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
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1.0,
      ),
      titleMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1.0,
      ),
      titleSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1.0,
      ),
      bodyLarge: TextStyle(
        fontSize: 26,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
        color: Colors.black,
      ),
      bodySmall: TextStyle(
        fontSize: 10,
        color: Colors.black,
      ),
      displayLarge: TextStyle(
        fontSize: 26,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 20,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        fontSize: 16,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
      labelLarge: TextStyle(
          fontFamily: "Montserrat", fontSize: 16, color: Colors.black),
      labelMedium: TextStyle(
          fontFamily: "Montserrat", fontSize: 14, color: Colors.black),
      labelSmall: TextStyle(
          fontFamily: "Montserrat", fontSize: 12, color: Colors.black),
    ),
    navigationBarTheme: NavigationBarThemeData(
      labelTextStyle: MaterialStateProperty.all(const TextStyle(
          fontFamily: "Montserrat", fontSize: 12, color: Colors.black)),
    ),
    applyElevationOverlayColor: false,
    scaffoldBackgroundColor: Colors.white,
    dialogBackgroundColor: HexColor('#FFF7EA'),
    bottomSheetTheme: BottomSheetThemeData(
        elevation: 0, backgroundColor: HexColor('#FFF7EA')),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0, backgroundColor: HexColor('#FFF7EA')),
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
      elevation: 0,
      backgroundColor: Colors.white,
    ));
