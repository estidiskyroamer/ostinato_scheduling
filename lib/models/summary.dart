// To parse this JSON data, do
//
//     final summary = summaryFromJson(jsonString);

import 'dart:convert';

Summary summaryFromJson(String str) => Summary.fromJson(json.decode(str));

String summaryToJson(Summary data) => json.encode(data.toJson());

class Summary {
  StudentSummary students;
  CourseSummary courses;

  Summary({
    required this.students,
    required this.courses,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        students: StudentSummary.fromJson(json["students"]),
        courses: CourseSummary.fromJson(json["courses"]),
      );

  Map<String, dynamic> toJson() => {
        "students": students.toJson(),
        "courses": courses.toJson(),
      };
}

class CourseSummary {
  int totalCourses;
  int totalCoursesDone;
  int totalCoursesNotStarted;
  int totalCoursesNotUpdated;
  int totalCoursesRescheduled;
  int totalCoursesCanceled;

  CourseSummary({
    required this.totalCourses,
    required this.totalCoursesDone,
    required this.totalCoursesNotStarted,
    required this.totalCoursesNotUpdated,
    required this.totalCoursesRescheduled,
    required this.totalCoursesCanceled,
  });

  factory CourseSummary.fromJson(Map<String, dynamic> json) => CourseSummary(
        totalCourses: json["totalCourses"],
        totalCoursesDone: json["totalCoursesDone"],
        totalCoursesNotStarted: json["totalCoursesNotStarted"],
        totalCoursesNotUpdated: json["totalCoursesNotUpdated"],
        totalCoursesRescheduled: json["totalCoursesRescheduled"],
        totalCoursesCanceled: json["totalCoursesCanceled"],
      );

  Map<String, dynamic> toJson() => {
        "totalCourses": totalCourses,
        "totalCoursesDone": totalCoursesDone,
        "totalCoursesNotStarted": totalCoursesNotStarted,
        "totalCoursesNotUpdated": totalCoursesNotUpdated,
        "totalCoursesRescheduled": totalCoursesRescheduled,
        "totalCoursesCanceled": totalCoursesCanceled,
      };
}

class StudentSummary {
  int totalStudents;
  int totalNewStudents;
  int totalLeavingStudents;
  int totalContinuingStudents;

  StudentSummary({
    required this.totalStudents,
    required this.totalNewStudents,
    required this.totalLeavingStudents,
    required this.totalContinuingStudents,
  });

  factory StudentSummary.fromJson(Map<String, dynamic> json) => StudentSummary(
        totalStudents: json["totalStudents"],
        totalNewStudents: json["totalNewStudents"],
        totalLeavingStudents: json["totalLeavingStudents"],
        totalContinuingStudents: json["totalContinuingStudents"],
      );

  Map<String, dynamic> toJson() => {
        "totalStudents": totalStudents,
        "totalNewStudents": totalNewStudents,
        "totalLeavingStudents": totalLeavingStudents,
        "totalContinuingStudents": totalContinuingStudents,
      };
}
