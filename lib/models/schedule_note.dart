// To parse this JSON data, do
//
//     final scheduleNoteList = scheduleNoteListFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:ostinato/models/common.dart';
import 'package:ostinato/models/schedule.dart';

ScheduleNoteList scheduleNoteListFromJson(String str) =>
    ScheduleNoteList.fromJson(json.decode(str));

String scheduleNoteListToJson(ScheduleNoteList data) =>
    json.encode(data.toJson());

class ScheduleNoteList {
  final List<ScheduleNote> data;
  final String message;
  final bool success;

  ScheduleNoteList({
    required this.data,
    required this.message,
    required this.success,
  });

  factory ScheduleNoteList.fromJson(Map<String, dynamic> json) =>
      ScheduleNoteList(
        data: List<ScheduleNote>.from(
            json["data"].map((x) => ScheduleNote.fromJson(x))),
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "success": success,
      };
}

class ScheduleNote {
  String? id;
  String scheduleId;
  String note;
  Schedule? schedule;
  DateTime? createdAt;

  ScheduleNote({
    this.id,
    required this.scheduleId,
    required this.note,
    this.schedule,
    this.createdAt,
  });

  factory ScheduleNote.fromJson(Map<String, dynamic> json) => ScheduleNote(
        id: json["id"],
        scheduleId: json["scheduleId"],
        note: json["note"],
        schedule: Schedule.fromJson(json["schedule"]),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "scheduleId": scheduleId,
        "note": note,
        "schedule": schedule?.toJson(),
        "createdAt": createdAt == null
            ? null
            : DateFormat('yyyy-MM-dd').format(createdAt!),
      };
}
