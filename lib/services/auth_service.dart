import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ostinato/common/components/components.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/main.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/pages/login.dart';
import 'package:ostinato/services/config.dart';

class AuthService {
  final Dio dio;
  AuthService([Dio? dioInstance]) : dio = dioInstance ?? Dio();

  Future<bool> login(String email, String password) async {
    try {
      Response response = await ServiceConfig().dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      if (response.statusCode == 200 && response.data['access_token'] != null) {
        String token = response.data['access_token'];
        await Config().storage.write(key: 'jwt_token', value: token);

        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
      return false;
    }
  }

  Future<bool> refresh() async {
    try {
      Response response = await ServiceConfig().dio.post('/refresh');
      if (response.statusCode == 200 && response.data['access_token'] != null) {
        String token = response.data['access_token'];
        await Config().storage.write(key: 'jwt_token', value: token);
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
      return false;
    }
  }

  Future<User?> getMe() async {
    User? user;
    try {
      Response response = await ServiceConfig().dio.post('/me');
      user = User.fromJson(response.data);
      await Config().storage.write(key: 'user', value: jsonEncode(response.data));
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
    }
    return user;
  }

  Future<void> logout() async {
    try {
      Response response = await ServiceConfig().dio.post('/logout');
      if (response.statusCode == 200) {
        await Config().storage.deleteAll();

        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } on DioException catch (e) {
      inspect(e);
    }
  }

  Future<void> updateFcmToken(String id, String? fcmToken) async {
    try {
      await ServiceConfig().dio.post('/fcm/update-token', data: {
        'id': id,
        'device_token': fcmToken,
      });
    } on DioException catch (e) {
      inspect(e);
    }
  }

  Future<String?> getToken() async {
    return await Config().storage.read(key: 'jwt_token');
  }
}
