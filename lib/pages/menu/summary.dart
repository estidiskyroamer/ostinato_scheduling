import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/summary.dart';
import 'package:ostinato/models/teacher.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/pages/menu/common.dart';
import 'package:ostinato/services/summary_service.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  late Future<Summary?> _summary;
  late Future<String?> _user;
  late Future<String?> _teacher;

  @override
  void initState() {
    _user = Config().storage.read(key: 'user');
    _teacher = Config().storage.read(key: 'teacher');
    getSummary();
    super.initState();
  }

  void getSummary() {
    if (mounted) {
      setState(() {
        _summary = SummaryService().getSummary();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime firstDayCurrentMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayCurrentMonth = DateTime(now.year, now.month + 1, 0);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Summary",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
                width: MediaQuery.sizeOf(context).width / 2,
                image: const AssetImage('assets/images/summary.jpeg')),
            Padding(padding: padding16),
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  getTeacherName(),
                  getTeacherCompany(),
                  /* Text("Monthly Summary for Teacher",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .merge(const TextStyle(color: Colors.black))), */
                  Padding(padding: padding4),
                  Text(
                      "Data ranged from ${DateFormat("dd MMMM yyyy").format(firstDayCurrentMonth)} to ${DateFormat("dd MMMM yyyy").format(lastDayCurrentMonth)}",
                      style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ),
            FutureBuilder(
              future: _summary,
              builder:
                  (BuildContext context, AsyncSnapshot<Summary?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 6,
                      child: Config().loadingIndicator,
                    ),
                  );
                }
                inspect(snapshot);
                if (!snapshot.hasData) {
                  return const Center(child: Text('No summary data'));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                StudentSummary studentSummary =
                    snapshot.data!.data.studentSummary;
                CourseSummary coursesSummary =
                    snapshot.data!.data.courseSummary;

                String totalNewStudents = studentSummary.totalNewStudents > 0
                    ? "+${studentSummary.totalNewStudents}"
                    : studentSummary.totalNewStudents.toString();

                String totalLeavingStudents =
                    studentSummary.totalLeavingStudents > 0
                        ? "-${studentSummary.totalLeavingStudents}"
                        : studentSummary.totalLeavingStudents.toString();
                return Column(
                  children: [
                    Padding(padding: padding16),
                    Text(
                      "Students",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Padding(padding: padding8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        summaryItem(context,
                            studentSummary.totalStudents.toString(), "Total"),
                        summaryItem(context, totalNewStudents, "New"),
                        summaryItem(context, totalLeavingStudents, "Leaving"),
                      ],
                    ),
                    Padding(padding: padding16),
                    Text(
                      "Courses",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Padding(padding: padding8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        summaryItem(
                            context,
                            (coursesSummary.done + coursesSummary.noStatus)
                                .toString(),
                            "Total"),
                        summaryItem(
                            context, coursesSummary.done.toString(), "Done"),
                        summaryItem(context, coursesSummary.canceled.toString(),
                            "Canceled"),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<String?> getTeacherName() {
    return FutureBuilder(
      future: _user,
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        String name = '';
        if (snapshot.hasData) {
          var jsonData = jsonDecode(snapshot.data!);
          User user = User.fromJson(jsonData);
          name = user.name;
        }
        return Text(name, style: Theme.of(context).textTheme.titleMedium);
      },
    );
  }

  FutureBuilder<String?> getTeacherCompany() {
    return FutureBuilder(
      future: _teacher,
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        String company = '';
        if (snapshot.hasData) {
          var jsonData = jsonDecode(snapshot.data!);
          Teacher teacher = Teacher.fromJson(jsonData);
          company = teacher.company!.name;
        }
        return Container(
          padding: padding4,
          child: Text(company,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .merge(const TextStyle(color: Colors.black))),
        );
      },
    );
  }
}
