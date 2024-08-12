import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/common/config.dart';
import 'dart:developer';

class AuthService {
  String baseUrl = Config().baseUrl;
  final storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    try {
      Response response = await Config().dio.post('$baseUrl/login', data: {
        'email': email,
        'password': password,
      });
      inspect(response);
      if (response.statusCode == 200 && response.data['access_token'] != null) {
        String token = response.data['access_token'];
        await storage.write(key: 'jwt_token', value: token);
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      inspect(e);
      return false;
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }
}
