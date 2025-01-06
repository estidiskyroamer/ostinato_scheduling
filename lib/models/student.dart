import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:ostinato/models/company.dart';
import 'package:ostinato/models/role.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/user.dart';

StudentList studentListFromJson(String str) =>
    StudentList.fromJson(json.decode(str));

String studentListToJson(StudentList data) => json.encode(data.toJson());

class StudentList {
  final List<User> data;
  final String message;
  final bool success;

  StudentList({
    required this.data,
    required this.message,
    required this.success,
  });

  factory StudentList.fromJson(Map<String, dynamic> json) => StudentList(
        data: List<User>.from(json["data"].map((x) => User.fromJson(x))),
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "success": success,
      };
}

StudentDetail studentDetailFromJson(String str) =>
    StudentDetail.fromJson(json.decode(str));

String studentDetailToJson(StudentDetail data) => json.encode(data.toJson());

class StudentDetail {
  final User data;
  final String message;
  final bool success;

  StudentDetail({
    required this.data,
    required this.message,
    required this.success,
  });

  factory StudentDetail.fromJson(Map<String, dynamic> json) => StudentDetail(
        data: User.fromJson(json["data"]),
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "success": success,
      };
}

class Student {
  final User user;
  final Role? role;
  final Company? company;
  List<Schedule>? schedules;

  Student({required this.user, this.role, this.company, this.schedules});

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        user: User.fromJson(json["user"]),
        role: json["role"] == null ? null : Role.fromJson(json["role"]),
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
        schedules: json["schedules"] == null || json["schedules"].length == 0
            ? null
            : List<Schedule>.from(
                json["schedules"].map((x) => Schedule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "role": role,
        "company": company,
        "schedules": schedules == null
            ? null
            : List<dynamic>.from(schedules!.map((x) => x.toJson())),
      };
}
