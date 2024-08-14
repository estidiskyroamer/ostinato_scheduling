import 'package:dio/dio.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/common/config.dart';
import 'dart:developer';

import 'package:ostinato/models/user.dart';

class UserService {
  String baseUrl = Config().baseUrl;

  Future<UserDetail?> getUserDetail(String id) async {
    UserDetail? student;
    try {
      Response response = await Config().dio.get('$baseUrl/users/show/$id');
      student = UserDetail.fromJson(response.data);
    } on DioException catch (e) {
      inspect(e);
    }
    return student;
  }
}
