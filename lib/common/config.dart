import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:loading_indicator/loading_indicator.dart';

class Config {
  String apiKey = "8accedf111e59fb160ff3561c7c90e0e";
  String accessToken =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YWNjZWRmMTExZTU5ZmIxNjBmZjM1NjFjN2M5MGUwZSIsInN1YiI6IjYxYmE4ZDk3MjhkN2ZlMDA0M2VjZjgzNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Geq8PJdk6by2Xl5fG0SOicHJFvUlxHpg_-xif7kn47Y";
  String baseUrl = "https://api.themoviedb.org/3";
  String imageUrl = "https://image.tmdb.org/t/p/";
  String backdropSizeLarge = "w1280";
  String backdropSize = "w780";
  String posterSize = "w500";
  String stillSize = "w300";
  String logoSize = "w92";
  String profileSize = "w185";
  Dio dio = Dio()
        ..interceptors.add(InterceptorsWrapper(onRequest: ((options, handler) {
          options.headers['accept'] = "application/json";
          options.headers['Authorization'] = "Bearer ${Config().accessToken}";
          return handler.next(options);
        })))
      /* ..interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90)) */
      ;
  LoadingIndicator loadingIndicator = LoadingIndicator(
    indicatorType: Indicator.ballPulseSync,
    colors: [
      Colors.white.withAlpha(50),
      Colors.white.withAlpha(125),
      Colors.white
    ],
  );
}

EdgeInsetsGeometry padding16 = const EdgeInsets.all(16);

EdgeInsetsGeometry padding8 = const EdgeInsets.all(8);

EdgeInsetsGeometry padding4 = const EdgeInsets.all(4);

ThemeData ostinatoTheme = ThemeData(
  fontFamily: 'Cormorant',
  colorSchemeSeed: Colors.white,
  textTheme: TextTheme(
    titleLarge: const TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      height: 1.0,
    ),
    titleMedium: const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      height: 1.0,
    ),
    titleSmall: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      height: 1.0,
    ),
    bodyLarge: const TextStyle(
      fontSize: 30,
      color: Colors.black,
    ),
    bodyMedium: const TextStyle(
      fontSize: 22,
      color: Colors.black,
    ),
    bodySmall: const TextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
    displayLarge: const TextStyle(
      fontSize: 32,
      fontStyle: FontStyle.italic,
      color: Colors.white,
    ),
    displayMedium: const TextStyle(
      fontSize: 24,
      fontStyle: FontStyle.italic,
      color: Colors.white,
    ),
    displaySmall: const TextStyle(
      fontSize: 16,
      fontStyle: FontStyle.italic,
      color: Colors.white,
    ),
    labelLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      color: Colors.black.withAlpha(100),
    ),
    labelMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      color: Colors.black.withAlpha(100),
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      color: Colors.black.withAlpha(100),
    ),
  ),
);
