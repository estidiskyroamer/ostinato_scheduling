import 'package:dio/dio.dart';
import 'package:ostinato/models/teacher.dart';
import 'package:ostinato/common/config.dart';
import 'dart:developer';

class TeacherService {
  String baseUrl = Config().baseUrl;

  Future<TeacherDetail?> getTeacherDetail() async {
    TeacherDetail? teacher;
    try {
      Response response = await Config().dio.get('$baseUrl/teachers/show');
      teacher = TeacherDetail.fromJson(response.data);
    } on DioException catch (e) {
      inspect(e);
    }
    return teacher;
  }
}
