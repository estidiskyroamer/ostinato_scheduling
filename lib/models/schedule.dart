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
  final Links links;
  final Meta meta;

  ScheduleList({
    required this.data,
    required this.message,
    required this.success,
    required this.links,
    required this.meta,
  });

  factory ScheduleList.fromJson(Map<String, dynamic> json) => ScheduleList(
        data:
            List<Schedule>.from(json["data"].map((x) => Schedule.fromJson(x))),
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

GroupedSchedule groupedScheduleFromJson(String str) =>
    GroupedSchedule.fromJson(json.decode(str));

String groupedScheduleToJson(GroupedSchedule data) =>
    json.encode(data.toJson());

class GroupedSchedule {
  Map<String, List<Schedule>> data;
  String message;
  bool success;
  Links links;

  GroupedSchedule({
    required this.data,
    required this.message,
    required this.success,
    required this.links,
  });

  factory GroupedSchedule.fromJson(Map<String, dynamic> json) =>
      GroupedSchedule(
        data: Map.from(json["data"]).map((k, v) =>
            MapEntry<String, List<Schedule>>(
                k, List<Schedule>.from(v.map((x) => Schedule.fromJson(x))))),
        message: json["message"],
        success: json["success"],
        links: Links.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "data": Map.from(data).map((k, v) => MapEntry<String, dynamic>(
            k, List<dynamic>.from(v.map((x) => x.toJson())))),
        "message": message,
        "success": success,
        "links": links.toJson(),
      };
}

class Schedule {
  final String? id;
  final String studentId;
  final String? studentName;
  final String teacherId;
  final String? teacherName;
  final String instrumentId;
  final String? instrumentName;
  final DateTime date;
  final String? createdBy;
  final String? statusId;
  final String startTime;
  final String endTime;

  Schedule({
    this.id,
    required this.studentId,
    this.studentName,
    required this.teacherId,
    this.teacherName,
    required this.instrumentId,
    this.instrumentName,
    required this.date,
    this.createdBy,
    this.statusId,
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
        statusId: json['statusId'] == null ? null : json["statusId"],
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
        "statusId": statusId,
        "startTime": startTime,
        "endTime": endTime,
      };
}
