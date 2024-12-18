import 'package:dio/dio.dart';
import 'package:ostinato/common/components/component.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/services/config.dart';

class StudentService {
  Future<StudentList?> getAllStudents() async {
    StudentList? studentList;
    try {
      Response response = await ServiceConfig().dio.get('/students/all');
      studentList = StudentList.fromJson(response.data);
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
    }
    return studentList;
  }

  Future<StudentList?> getStudents() async {
    StudentList? studentList;
    try {
      Response response = await ServiceConfig().dio.get('/students');
      studentList = StudentList.fromJson(response.data);
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
    }
    return studentList;
  }

  Future<StudentDetail?> getStudentDetail(String id) async {
    StudentDetail? student;
    try {
      Response response = await ServiceConfig().dio.get('/students/show/$id');
      student = StudentDetail.fromJson(response.data);
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
    }
    return student;
  }

  Future<ScheduleList?> getStudentSchedule(String id) async {
    ScheduleList? schedule;
    try {
      String url = '/students/showSchedule/$id';
      Response response = await ServiceConfig().dio.get(url);
      schedule = ScheduleList.fromJson(response.data);
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
    }
    return schedule;
  }

  Future<bool> createStudent(Student student) async {
    Map<String, dynamic> params = student.toJson();

    if (params['user'] != null) {
      User paramUser = student.user;
      Map<String, dynamic> user = paramUser.toJson();
      params.remove('user');
      params.addAll(user);
    }
    try {
      Response response =
          await ServiceConfig().dio.post('/students', data: params);
      if (response.statusCode == 200) {
        toastNotification(response.data['message']);
        return true;
      }
      return false;
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
      return false;
    }
  }

  Future<bool> updateStudent(Student student) async {
    Map<String, dynamic> params = student.toJson();

    if (params['user'] != null) {
      User paramUser = student.user;
      Map<String, dynamic> user = paramUser.toJson();
      params.remove('user');
      params.addAll(user);
    }
    try {
      Response response = await ServiceConfig()
          .dio
          .put('/students/student/${student.id}', data: params);
      if (response.statusCode == 200) {
        toastNotification(response.data['message']);
        return true;
      }
      return false;
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
      return false;
    }
  }

  Future<bool> deleteStudent(Student student) async {
    try {
      Response response =
          await ServiceConfig().dio.delete('/students/student/${student.id}');
      return true;
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
      return false;
    }
  }
}
