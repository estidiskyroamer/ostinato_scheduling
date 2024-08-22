import 'package:dio/dio.dart';
import 'package:ostinato/models/teacher.dart';
import 'package:ostinato/common/config.dart';
import 'dart:developer';

import 'package:ostinato/services/config.dart';

class TeacherService {
  Future<TeacherDetail?> getTeacherDetail() async {
    TeacherDetail? teacher;
    try {
      Response response = await ServiceConfig().dio.get('/teachers/show');
      teacher = TeacherDetail.fromJson(response.data);
      Config().storage.write(key: 'teacher_id', value: teacher.data.id);
      Config().storage.write(key: 'teacher_name', value: teacher.data.name);
    } on DioException catch (e) {
      inspect(e);
    }
    return teacher;
  }
}
