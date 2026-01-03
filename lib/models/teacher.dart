// To parse this JSON data, do
//
//     final teacherDetail = teacherDetailFromJson(jsonString);

import 'dart:convert';

import 'package:ostinato/models/company.dart';
import 'package:ostinato/models/role.dart';
import 'package:ostinato/models/user.dart';

TeacherDetail teacherDetailFromJson(String str) =>
    TeacherDetail.fromJson(json.decode(str));

String teacherDetailToJson(TeacherDetail data) => json.encode(data.toJson());

class TeacherDetail {
  Teacher data;
  String message;
  bool success;

  TeacherDetail({
    required this.data,
    required this.message,
    required this.success,
  });

  factory TeacherDetail.fromJson(Map<String, dynamic> json) => TeacherDetail(
        data: Teacher.fromJson(json["data"]),
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "success": success,
      };
}

class Teacher {
  final User user;
  final Role? role;
  final Company? company;

  Teacher({
    required this.user,
    this.role,
    this.company,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
      user: User.fromJson(json["user"]),
      role: json["role"] == null ? null : Role.fromJson(json["role"]),
      company:
          json["company"] == null ? null : Company.fromJson(json["company"]));

  Map<String, dynamic> toJson() =>
      {"name": user.name, "user": user, "role": role, "company": company};
}
