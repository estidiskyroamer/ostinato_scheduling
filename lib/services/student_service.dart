import 'package:dio/dio.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/common/config.dart';
import 'dart:developer';

class StudentService {
  String baseUrl = Config().baseUrl;

  Future<StudentList?> getStudents() async {
    StudentList? studentList;
    try {
      Response response = await Config().dio.get('$baseUrl/api/students');
      studentList = StudentList.fromJson(response.data);
    } on DioException catch (e) {
      inspect(e);
    }
    return studentList;
  }

  Future<StudentDetail?> getStudentDetail(String id) async {
    StudentDetail? student;
    try {
      Response response =
          await Config().dio.get('$baseUrl/api/students/show/$id');
      student = StudentDetail.fromJson(response.data);
    } on DioException catch (e) {
      inspect(e);
    }
    return student;
  }
}
