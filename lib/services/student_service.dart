import 'package:dio/dio.dart';
import 'package:ostinato/common/components/components.dart';
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

  Future<StudentList?> getStudents(int isActive) async {
    StudentList? studentList;
    try {
      Response response = await ServiceConfig().dio.get('/students?isActive=$isActive');
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

  Future<ScheduleList?> getStudentSchedule({int? year, int? month, String? id}) async {
    ScheduleList? schedule;
    try {
      String url = '/students/showSchedule/$id?year=$year&month=$month';
      Response response = await ServiceConfig().dio.get(url);
      schedule = ScheduleList.fromJson(response.data);
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
    }
    return schedule;
  }

  Future<User?> createStudent(User student) async {
    Map<String, dynamic> params = student.toJson();
    User? updatedUser;

    if (params['user'] != null) {
      User paramUser = student;
      Map<String, dynamic> user = paramUser.toJson();
      params.remove('user');
      params.addAll(user);
    }
    try {
      Response response = await ServiceConfig().dio.post('/students', data: params);
      if (response.statusCode == 200) {
        UserDetail updatedUserDetail = UserDetail.fromJson(response.data);
        updatedUser = updatedUserDetail.data;
      }
      toastNotification(response.data['message']);
      return updatedUser;
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
      return updatedUser;
    }
  }

  Future<User?> updateStudent(User student) async {
    Map<String, dynamic> params = student.toJson();
    User? updatedUser;

    if (params['user'] != null) {
      User paramUser = student;
      Map<String, dynamic> user = paramUser.toJson();
      params.remove('user');
      params.addAll(user);
    }
    try {
      Response response = await ServiceConfig().dio.put('/students/student/${student.id}', data: params);
      if (response.statusCode == 200) {
        UserDetail updatedUserDetail = UserDetail.fromJson(response.data);
        updatedUser = updatedUserDetail.data;
      }
      toastNotification(response.data['message']);
      return updatedUser;
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
      return updatedUser;
    }
  }

  Future<bool> deleteStudent(Student student) async {
    try {
      Response response = await ServiceConfig().dio.delete('/students/student/${student.user.id}');
      toastNotification(response.data['message']);
      return true;
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
      return false;
    }
  }
}
