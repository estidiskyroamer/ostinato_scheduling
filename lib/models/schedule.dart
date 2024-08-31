// To parse this JSON data, do
//
//     final scheduleList = scheduleListFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:ostinato/models/common.dart';
import 'package:ostinato/models/instrument.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/models/teacher.dart';

ScheduleList scheduleListFromJson(String str) =>
    ScheduleList.fromJson(json.decode(str));

String scheduleListToJson(ScheduleList data) => json.encode(data.toJson());

class ScheduleList {
  final List<Schedule> data;
  final String message;
  final bool success;

  ScheduleList({
    required this.data,
    required this.message,
    required this.success,
  });

  factory ScheduleList.fromJson(Map<String, dynamic> json) => ScheduleList(
        data:
            List<Schedule>.from(json["data"].map((x) => Schedule.fromJson(x))),
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "success": success,
      };
}

class Schedule {
  final String? id;
  final DateTime date;
  final String? createdBy;
  final String? status;
  final String startTime;
  final String endTime;
  final Student student;
  final Teacher teacher;
  final Instrument instrument;

  Schedule({
    this.id,
    required this.date,
    this.createdBy,
    this.status,
    required this.startTime,
    required this.endTime,
    required this.student,
    required this.teacher,
    required this.instrument,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        createdBy: json['createdBy'] == null ? null : json["createdBy"],
        status: json['status'] == null ? null : json["status"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        student: Student.fromJson(json["student"]),
        teacher: Teacher.fromJson(json["teacher"]),
        instrument: Instrument.fromJson(json["instrument"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": DateFormat('yyyy-MM-dd').format(date),
        "createdBy": createdBy,
        "status": status,
        "startTime": startTime,
        "endTime": endTime,
        "student": student.toJson(),
        "teacher": teacher.toJson(),
        "instrument": instrument.toJson(),
      };
}
