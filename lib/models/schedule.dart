// To parse this JSON data, do
//
//     final scheduleList = scheduleListFromJson(jsonString);

import 'dart:convert';

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
  Meta meta;

  GroupedSchedule({
    required this.data,
    required this.message,
    required this.success,
    required this.links,
    required this.meta,
  });

  factory GroupedSchedule.fromJson(Map<String, dynamic> json) =>
      GroupedSchedule(
        data: Map.from(json["data"]).map((k, v) =>
            MapEntry<String, List<Schedule>>(
                k, List<Schedule>.from(v.map((x) => Schedule.fromJson(x))))),
        message: json["message"],
        success: json["success"],
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": Map.from(data).map((k, v) => MapEntry<String, dynamic>(
            k, List<dynamic>.from(v.map((x) => x.toJson())))),
        "message": message,
        "success": success,
        "links": links.toJson(),
        "meta": meta.toJson(),
      };
}

class Schedule {
  final String id;
  final String? studentId;
  final String studentName;
  final String? teacherId;
  final String teacherName;
  final String? instrumentId;
  final String instrumentName;
  final DateTime date;
  final String? createdBy;
  final String? statusId;
  final String startTime;
  final String endTime;

  Schedule({
    required this.id,
    this.studentId,
    required this.studentName,
    this.teacherId,
    required this.teacherName,
    this.instrumentId,
    required this.instrumentName,
    required this.date,
    this.createdBy,
    this.statusId,
    required this.startTime,
    required this.endTime,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["id"],
        studentId: json['studentId'] == null ? null : json["studentId"],
        studentName: json["studentName"],
        teacherId: json['teacherId'] == null ? null : json["teacherId"],
        teacherName: json["teacherName"],
        instrumentId:
            json['instrumentId'] == null ? null : json["instrumentId"],
        instrumentName: json["instrumentName"],
        date: DateTime.parse(json["date"]),
        createdBy: json["createdBy"],
        statusId: json["statusId"],
        startTime: json["startTime"],
        endTime: json["endTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "studentId": studentId?.toString(),
        "studentName": studentName.toString(),
        "teacherId": teacherId?.toString(),
        "teacherName": teacherName.toString(),
        "instrumentId": instrumentId?.toString(),
        "instrumentName": instrumentName.toString(),
        "date": date.toString(),
        "createdBy": createdBy,
        "statusId": statusId,
        "startTime": startTime,
        "endTime": endTime,
      };
}
