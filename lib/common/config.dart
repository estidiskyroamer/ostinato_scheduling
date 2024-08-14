import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:loading_indicator/loading_indicator.dart';
import 'package:ostinato/pages/login.dart';
import 'package:ostinato/services/auth_service.dart';

class Config {
  String baseUrl = "http://localhost:8000/api";
  final storage = const FlutterSecureStorage();
  Dio dio = Dio()
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: ((options, handler) async {
          String? token = await AuthService().getToken();
          options.headers['accept'] = "application/json";
          options.headers['Authorization'] = "Bearer $token";
          return handler.next(options);
        }),
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await AuthService().logout();
          } else {
            return handler.next(error);
          }
        },
      ),
    );
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
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1.0,
      ),
      titleMedium: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1.0,
      ),
      titleSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1.0,
      ),
      bodyLarge: TextStyle(
        fontSize: 24,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      bodySmall: TextStyle(
        fontSize: 8,
        color: Colors.black,
      ),
      displayLarge: TextStyle(
        fontSize: 26,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 18,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        fontSize: 10,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
      labelLarge: TextStyle(
          fontFamily: "Montserrat", fontSize: 18, color: Colors.black54),
      labelMedium: TextStyle(
          fontFamily: "Montserrat", fontSize: 14, color: Colors.black54),
      labelSmall: TextStyle(
          fontFamily: "Montserrat", fontSize: 10, color: Colors.black54),
    ),
    navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: MaterialStateProperty.all(const TextStyle(
            fontFamily: "Montserrat", fontSize: 10, color: Colors.black54))));
