import 'package:dio/dio.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/common/config.dart';
import 'dart:developer';

import 'package:ostinato/models/user.dart';
import 'package:ostinato/services/config.dart';

class UserService {
  Future<UserDetail?> getUserDetail(String id) async {
    UserDetail? student;
    try {
      Response response = await ServiceConfig().dio.get('/users/show/$id');
      student = UserDetail.fromJson(response.data);
    } on DioException catch (e) {
      inspect(e);
    }
    return student;
  }

  Future<User?> createUser(User user) async {
    User? newUser;
    Map<String, dynamic> params = user.toJson();
    try {
      Response response =
          await ServiceConfig().dio.post('/users', data: params);
      if (response.statusCode == 200) {
        UserDetail newUserDetail = UserDetail.fromJson(response.data);
        newUser = newUserDetail.data;
      }
      return newUser;
    } on DioException catch (e) {
      inspect(e);
      return newUser;
    }
  }
}
