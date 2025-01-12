import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ostinato/common/components/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/teacher.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/services/config.dart';

class TeacherService {
  Future<TeacherDetail?> getTeacherDetail() async {
    TeacherDetail? teacher;
    try {
      Response response = await ServiceConfig().dio.get('/teachers/show');
      teacher = TeacherDetail.fromJson(response.data);
      Config()
          .storage
          .write(key: 'teacher', value: jsonEncode(teacher.data.toJson()));
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
    }
    return teacher;
  }

  Future<User?> createTeacher(User teacher) async {
    Map<String, dynamic> params = teacher.toJson();
    User? updatedUser;

    if (params['user'] != null) {
      User paramUser = teacher;
      Map<String, dynamic> user = paramUser.toJson();
      params.remove('user');
      params.addAll(user);
    }
    try {
      Response response =
          await ServiceConfig().dio.post('/teachers', data: params);
      if (response.statusCode == 200) {
        UserDetail updatedUserDetail = UserDetail.fromJson(response.data);
        updatedUser = updatedUserDetail.data;
      }
      toastNotification(
          'You have successfully registered as a teacher. Check your email to verify your account.');
      return updatedUser;
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
      return updatedUser;
    }
  }
}
