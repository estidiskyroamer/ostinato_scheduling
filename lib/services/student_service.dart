import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/services/config.dart';

class StudentService {
  Future<StudentList?> getAllStudents() async {
    StudentList? studentList;
    try {
      Response response = await ServiceConfig().dio.get('/students/all');
      studentList = StudentList.fromJson(response.data);
    } on DioException catch (e) {
      inspect(e);
    }
    return studentList;
  }

  Future<StudentList?> getStudents() async {
    StudentList? studentList;
    try {
      Response response = await ServiceConfig().dio.get('/students');
      studentList = StudentList.fromJson(response.data);
    } on DioException catch (e) {
      inspect(e);
    }
    return studentList;
  }

  Future<StudentDetail?> getStudentDetail(String id) async {
    StudentDetail? student;
    try {
      Response response = await ServiceConfig().dio.get('/students/show/$id');
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
          await ServiceConfig().dio.post('/students', data: params);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      inspect(e);
      return false;
    }
  }

  Future<bool> updateStudent(Student student) async {
    Map<String, dynamic> params = student.toJson();
    try {
      Response response = await ServiceConfig()
          .dio
          .put('/students/student/${student.id}', data: params);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      inspect(e);
      return false;
    }
  }

  Future<bool> deleteStudent(Student student) async {
    try {
      Response response =
          await ServiceConfig().dio.delete('/students/student/${student.id}');
      inspect(response);
      return true;
    } on DioException catch (e) {
      inspect(e);
      return false;
    }
  }
}