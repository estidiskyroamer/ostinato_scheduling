// To parse this JSON data, do
//
//     final summary = summaryFromJson(jsonString);

import 'dart:convert';

Summary summaryFromJson(String str) => Summary.fromJson(json.decode(str));

String summaryToJson(Summary data) => json.encode(data.toJson());

class Summary {
  Data data;
  String message;
  bool success;

  Summary({
    required this.data,
    required this.message,
    required this.success,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        data: Data.fromJson(json["data"]),
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "success": success,
      };
}

class Data {
  StudentSummary studentSummary;
  CourseSummary courseSummary;

  Data({
    required this.studentSummary,
    required this.courseSummary,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        studentSummary: StudentSummary.fromJson(json["students"]),
        courseSummary: CourseSummary.fromJson(json["courses"]),
      );

  Map<String, dynamic> toJson() => {
        "students": studentSummary.toJson(),
        "courses": courseSummary.toJson(),
      };
}

class CourseSummary {
  int canceled;
  int done;
  int noStatus;

  CourseSummary({
    required this.canceled,
    required this.done,
    required this.noStatus,
  });

  factory CourseSummary.fromJson(Map<String, dynamic> json) => CourseSummary(
        canceled: json["canceled"],
        done: json["done"],
        noStatus: json["no_status"],
      );

  Map<String, dynamic> toJson() => {
        "canceled": canceled,
        "done": done,
        "no_status": noStatus,
      };
}

class StudentSummary {
  int totalStudents;
  int totalNewStudents;
  int totalLeavingStudents;

  StudentSummary({
    required this.totalStudents,
    required this.totalNewStudents,
    required this.totalLeavingStudents,
  });

  factory StudentSummary.fromJson(Map<String, dynamic> json) => StudentSummary(
        totalStudents: json["total_students"],
        totalNewStudents: json["total_new_students"],
        totalLeavingStudents: json["total_leaving_students"],
      );

  Map<String, dynamic> toJson() => {
        "total_students": totalStudents,
        "total_new_students": totalNewStudents,
        "total_leaving_students": totalLeavingStudents,
      };
}
