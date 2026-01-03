import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/services/auth_service.dart';
import 'package:ostinato/common/config.dart';

class ServiceConfig {
  late Dio dio;

  ServiceConfig() {
    dio = Dio(BaseOptions(baseUrl: "https://musiclesson-scheduling.vercel.app/api/api"))
      // baseUrl: "http://localhost:8000/api"))
      ..interceptors.add(DioInterceptor());
  }
}

class DioInterceptor extends Interceptor {
  Dio dio = Dio(BaseOptions(baseUrl: "https://musiclesson-scheduling.vercel.app/api/api"));
  // baseUrl: "http://localhost:8000/api"));

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = await AuthService().getToken();
    options.headers['accept'] = "application/json";
    options.headers['Authorization'] = "Bearer $token";

    if (options.method == 'POST') {
      options.data ??= {};
      switch (options.data['isActive']) {
        case 1:
          options.data['activeDate'] = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
          break;
        case 0:
          options.data['inactiveDate'] = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
        default:
          break;
      }
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Check if backend auto-refreshed the token
    // The new backend adds these headers when token was expired but refreshable
    String? tokenRefreshed = response.headers.value('x-token-refreshed');
    String? newToken = response.headers.value('x-new-token');

    if (tokenRefreshed == 'true' && newToken != null) {
      // Store the new token automatically
      await Config().storage.write(key: 'jwt_token', value: newToken);
    }

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        Map<String, dynamic> response = err.response!.data;
        
        // Check for token expiration errors (both old 'message' and new 'error' keys)
        String? errorMessage = response['error'] ?? response['message'];
        String? errorCode = response['code'];
        
        // Token expired but still refreshable - try manual refresh as fallback
        if (errorMessage == "Token has expired" || 
            errorMessage == "Token has expired and cannot be refreshed") {
          
          // If code indicates refresh is required, the auto-refresh already failed
          // so we need to re-authenticate
          if (errorCode == 'TOKEN_EXPIRED_REFRESH_REQUIRED') {
            await AuthService().logout();
            return handler.next(err);
          }
          
          // Try manual refresh as fallback (for old token flow)
          bool isRefreshed = await AuthService().refresh();
          if (isRefreshed) {
            String? newToken = await AuthService().getToken();
            return handler.resolve(await _retry(err.requestOptions, newToken));
          } else {
            await AuthService().logout();
            return handler.next(err);
          }
        } else if (errorCode == 'TOKEN_INVALID' || errorCode == 'TOKEN_ABSENT') {
          // Invalid or missing token - need to re-authenticate
          await AuthService().logout();
          return handler.next(err);
        }
      } on Exception catch (_) {
        await AuthService().logout();
        return handler.next(err);
      }
      await AuthService().logout();
    }
    return handler.next(err);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions, String? token) async {
    final options = Options(
      method: requestOptions.method,
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    var response = dio.request<dynamic>(
      requestOptions.path, 
      data: requestOptions.data, 
      queryParameters: requestOptions.queryParameters, 
      options: options
    );
    return response;
  }
}
