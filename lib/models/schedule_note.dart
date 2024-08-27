// To parse this JSON data, do
//
//     final scheduleNoteList = scheduleNoteListFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:ostinato/models/common.dart';

ScheduleNoteList scheduleNoteListFromJson(String str) =>
    ScheduleNoteList.fromJson(json.decode(str));

String scheduleNoteListToJson(ScheduleNoteList data) =>
    json.encode(data.toJson());

class ScheduleNoteList {
  List<ScheduleNote> scheduleNote;
  String message;
  bool success;
  Links links;
  Meta meta;

  ScheduleNoteList({
    required this.scheduleNote,
    required this.message,
    required this.success,
    required this.links,
    required this.meta,
  });

  factory ScheduleNoteList.fromJson(Map<String, dynamic> json) =>
      ScheduleNoteList(
        scheduleNote: List<ScheduleNote>.from(
            json["data"].map((x) => ScheduleNote.fromJson(x))),
        message: json["message"],
        success: json["success"],
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "scheduleNote": List<dynamic>.from(scheduleNote.map((x) => x.toJson())),
        "message": message,
        "success": success,
        "links": links.toJson(),
        "meta": meta.toJson(),
      };
}

class ScheduleNote {
  String? id;
  String scheduleId;
  String note;
  DateTime? createdAt;

  ScheduleNote({
    this.id,
    required this.scheduleId,
    required this.note,
    this.createdAt,
  });

  factory ScheduleNote.fromJson(Map<String, dynamic> json) => ScheduleNote(
        id: json["id"],
        scheduleId: json["scheduleId"],
        note: json["note"],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "scheduleId": scheduleId,
        "note": note,
        "createdAt": createdAt == null
            ? null
            : DateFormat('yyyy-MM-dd').format(createdAt!),
      };
}
