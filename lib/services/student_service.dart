import 'package:dio/dio.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/common/config.dart';
import 'dart:developer';

class StudentService {
  String baseUrl = Config().baseUrl;

  Future<StudentList?> getAllStudents() async {
    StudentList? studentList;
    try {
      Response response = await Config().dio.get('$baseUrl/students/all');
      studentList = StudentList.fromJson(response.data);
    } on DioException catch (e) {
      inspect(e);
    }
    return studentList;
  }

  Future<StudentList?> getStudents() async {
    StudentList? studentList;
    try {
      Response response = await Config().dio.get('$baseUrl/students');
      studentList = StudentList.fromJson(response.data);
    } on DioException catch (e) {
      inspect(e);
    }
    return studentList;
  }

  Future<StudentDetail?> getStudentDetail(String id) async {
    StudentDetail? student;
    try {
      Response response = await Config().dio.get('$baseUrl/students/show/$id');
      student = StudentDetail.fromJson(response.data);
    } on DioException catch (e) {
      inspect(e);
    }
    return student;
  }

  Future<bool> createStudent(Student student) async {
    Map<String, dynamic> params = student.toJson();
    try {
      Response response =
          await Config().dio.post('$baseUrl/students', data: params);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      inspect(e);
      return false;
    }
  }
}
