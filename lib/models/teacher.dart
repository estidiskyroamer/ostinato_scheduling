// To parse this JSON data, do
//
//     final teacherDetail = teacherDetailFromJson(jsonString);

import 'dart:convert';

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
  final String id;
  final String userId;
  final String name;
  final int isActive;
  final DateTime activeDate;
  final DateTime? inactiveDate;

  Teacher({
    required this.id,
    required this.userId,
    required this.name,
    required this.isActive,
    required this.activeDate,
    this.inactiveDate,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
        id: json["id"],
        userId: json["userId"],
        name: json["name"],
        isActive: json["isActive"],
        activeDate: DateTime.parse(json["activeDate"]),
        inactiveDate: json['inactiveDate'] == null
            ? null
            : DateTime.parse(json['inactiveDate']),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "name": name,
        "isActive": isActive,
        "activeDate": activeDate.toString(),
        "inactiveDate": inactiveDate?.toString(),
      };
}
