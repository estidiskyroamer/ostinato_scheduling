import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:ostinato/models/common.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/user.dart';

StudentList studentListFromJson(String str) =>
    StudentList.fromJson(json.decode(str));

String studentListToJson(StudentList data) => json.encode(data.toJson());

class StudentList {
  final List<Student> data;
  final String message;
  final bool success;

  StudentList({
    required this.data,
    required this.message,
    required this.success,
  });

  factory StudentList.fromJson(Map<String, dynamic> json) => StudentList(
        data: List<Student>.from(json["data"].map((x) => Student.fromJson(x))),
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
  String? id;
  final String address;
  final DateTime birthDate;
  final User user;
  final int isActive;
  final DateTime? activeDate;
  final DateTime? inactiveDate;
  List<Schedule>? schedules;

  Student({
    this.id,
    required this.address,
    required this.birthDate,
    required this.user,
    required this.isActive,
    this.activeDate,
    this.inactiveDate,
    this.schedules,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["id"],
        address: json["address"],
        birthDate: DateTime.parse(json["birthDate"]),
        user: User.fromJson(json["user"]),
        isActive: json["isActive"],
        activeDate: json['activeDate'] == null
            ? null
            : DateTime.parse(json['activeDate']),
        inactiveDate: json['inactiveDate'] == null
            ? null
            : DateTime.parse(json['inactiveDate']),
        schedules: json["schedules"] == null || json["schedules"].length == 0
            ? null
            : List<Schedule>.from(
                json["schedules"].map((x) => Schedule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "userId": user.id,
        "address": address,
        "birthDate": DateFormat('yyyy-MM-dd').format(birthDate),
        "isActive": isActive,
        "activeDate": activeDate?.toString(),
        "inactiveDate": inactiveDate?.toString(),
        "schedules": schedules == null
            ? null
            : List<dynamic>.from(schedules!.map((x) => x.toJson())),
      };
}
