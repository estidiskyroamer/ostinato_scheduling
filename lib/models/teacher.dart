// To parse this JSON data, do
//
//     final teacherDetail = teacherDetailFromJson(jsonString);

import 'dart:convert';

import 'package:ostinato/models/company.dart';
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
  final String? id;
  final User user;
  final int isActive;
  final String? companyId;
  final String? companyCode;
  final Company? company;

  Teacher({
    this.id,
    required this.user,
    required this.isActive,
    this.companyId,
    this.companyCode,
    this.company,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
      id: json["id"],
      user: User.fromJson(json["user"]),
      isActive: json["isActive"],
      companyId: json["companyId"],
      companyCode: json["companyCode"],
      company:
          json["company"] == null ? null : Company.fromJson(json["company"]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": user.name,
        "user": user,
        "isActive": isActive,
        "companyId": companyId,
        "companyCode": companyCode,
        "company": company
      };
}
