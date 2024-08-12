import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:ostinato/models/common.dart';
import 'package:ostinato/models/schedule.dart';

StudentList studentListFromJson(String str) =>
    StudentList.fromJson(json.decode(str));

String studentListToJson(StudentList data) => json.encode(data.toJson());

class StudentList {
  final List<Student> data;
  final String message;
  final bool success;
  final Links links;
  final Meta meta;

  StudentList({
    required this.data,
    required this.message,
    required this.success,
    required this.links,
    required this.meta,
  });

  factory StudentList.fromJson(Map<String, dynamic> json) => StudentList(
        data: List<Student>.from(json["data"].map((x) => Student.fromJson(x))),
        message: json["message"],
        success: json["success"],
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "success": success,
        "links": links.toJson(),
        "meta": meta.toJson(),
      };
}

StudentDetail studentDetailFromJson(String str) =>
    StudentDetail.fromJson(json.decode(str));

String studentDetailToJson(StudentDetail data) => json.encode(data.toJson());

class StudentDetail {
  final Student data;
  final String message;
  final bool success;

  StudentDetail({
    required this.data,
    required this.message,
    required this.success,
  });

  factory StudentDetail.fromJson(Map<String, dynamic> json) => StudentDetail(
        data: Student.fromJson(json["data"]),
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
  final String id;
  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final DateTime birthDate;
  final int isActive;
  final DateTime activeDate;
  final DateTime? inactiveDate;
  List<Schedule> schedules;

  Student({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
    required this.isActive,
    required this.activeDate,
    required this.inactiveDate,
    required this.schedules,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["id"],
        userId: json["userId"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        birthDate: DateTime.parse(json["birthDate"]),
        isActive: json["isActive"],
        activeDate: DateTime.parse(json["activeDate"]),
        inactiveDate: json['inactiveDate'] == null
            ? null
            : DateTime.parse(json['inactiveDate']),
        schedules: List<Schedule>.from(
            json["schedules"].map((x) => Schedule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "birthDate": birthDate.toString(),
        "isActive": isActive,
        "activeDate": activeDate.toString(),
        "inactiveDate": inactiveDate?.toString(),
        "schedules": List<dynamic>.from(schedules.map((x) => x.toJson())),
      };
}
