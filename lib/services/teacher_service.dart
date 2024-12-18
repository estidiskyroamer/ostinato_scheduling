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

  Future<bool> createTeacher(Teacher teacher) async {
    Map<String, dynamic> params = teacher.toJson();

    if (params['user'] != null) {
      User paramUser = teacher.user;
      Map<String, dynamic> user = paramUser.toJson();
      params.remove('user');
      params.addAll(user);
    }
    try {
      Response response =
          await ServiceConfig().dio.post('/teachers', data: params);
      if (response.statusCode == 200) {
        toastNotification(response.data['message']);
        return true;
      }
      return false;
    } on DioException catch (e) {
      inspect(e);
      toastNotification(e.response!.data['errors'][0]);
      return false;
    }
  }
}
