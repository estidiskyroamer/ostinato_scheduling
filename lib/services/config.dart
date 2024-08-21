import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/services/auth_service.dart';

class ServiceConfig {
  late Dio dio;
  late Dio refreshDio;

  ServiceConfig() {
    dio = Dio(BaseOptions(baseUrl: "http://localhost:8000/api"))
      ..interceptors.add(DioInterceptor());
  }
}

class DioInterceptor extends Interceptor {
  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8000/api"));

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = await AuthService().getToken();
    options.headers['accept'] = "application/json";
    options.headers['Authorization'] = "Bearer $token";

    if (options.method == 'POST') {
      options.data ??= {};
      String? userId = await const FlutterSecureStorage().read(key: 'user_id');
      if (userId != null) {
        options.data['createdBy'] = userId;
      }
      switch (options.data['isActive']) {
        case 1:
          options.data['activeDate'] =
              DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
          break;
        case 0:
          options.data['inactiveDate'] =
              DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
        default:
          break;
      }
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    switch (err.response?.statusCode) {
      case 401:
        bool response = await AuthService().refresh();
        try {
          if (response) {
            String? newToken = await AuthService().getToken();
            return (handler
                .resolve(await _retry(err.requestOptions, newToken)));
          } else {
            await AuthService().logout();
            return handler.next(err);
          }
        } on DioException catch (e) {
          await AuthService().logout();
          return handler.next(err);
        }
      default:
        break;
    }
  }

  Future<Response<dynamic>> _retry(
      RequestOptions requestOptions, String? token) async {
    final options = Options(
      method: requestOptions.method,
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    var response = dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
    return response;
  }
}
