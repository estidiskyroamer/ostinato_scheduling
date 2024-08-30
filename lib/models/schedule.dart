// To parse this JSON data, do
//
//     final scheduleList = scheduleListFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:ostinato/models/common.dart';

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

GroupedSchedule groupedScheduleFromJson(String str) =>
    GroupedSchedule.fromJson(json.decode(str));

String groupedScheduleToJson(GroupedSchedule data) =>
    json.encode(data.toJson());

class GroupedSchedule {
  Map<String, List<Schedule>> data;
  String message;
  bool success;

  GroupedSchedule({
    required this.data,
    required this.message,
    required this.success,
  });

  factory GroupedSchedule.fromJson(Map<String, dynamic> json) =>
      GroupedSchedule(
        data: Map.from(json["data"]).map(
          (k, v) => MapEntry<String, List<Schedule>>(
            k,
            List<Schedule>.from(
              v.map(
                (x) => Schedule.fromJson(x),
              ),
            ),
          ),
        ),
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "data": Map.from(data).map(
          (k, v) => MapEntry<String, dynamic>(
            k,
            List<dynamic>.from(
              v.map(
                (x) => x.toJson(),
              ),
            ),
          ),
        ),
        "message": message,
        "success": success,
      };
}

class Schedule {
  final String? id;
  final String? studentId;
  final String? studentName;
  final String? teacherId;
  final String? teacherName;
  final String? instrumentId;
  final String? instrumentName;
  final DateTime date;
  final String? createdBy;
  final String? status;
  final String startTime;
  final String endTime;

  Schedule({
    this.id,
    this.studentId,
    this.studentName,
    this.teacherId,
    this.teacherName,
    this.instrumentId,
    this.instrumentName,
    required this.date,
    this.createdBy,
    this.status,
    required this.startTime,
    required this.endTime,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["id"],
        studentId: json["studentId"],
        studentName: json['studentName'] == null ? null : json["studentName"],
        teacherId: json["teacherId"],
        teacherName: json['teacherName'] == null ? null : json["teacherName"],
        instrumentId: json["instrumentId"],
        instrumentName:
            json['instrumentName'] == null ? null : json["instrumentName"],
        date: DateTime.parse(json["date"]),
        createdBy: json['createdBy'] == null ? null : json["createdBy"],
        status: json['status'] == null ? null : json["status"],
        startTime: json["startTime"],
        endTime: json["endTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "studentId": studentId.toString(),
        "teacherId": teacherId.toString(),
        "instrumentId": instrumentId.toString(),
        "date": DateFormat('yyyy-MM-dd').format(date),
        "createdBy": createdBy,
        "status": status,
        "startTime": startTime,
        "endTime": endTime,
      };
}
