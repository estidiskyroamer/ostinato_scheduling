import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/schedule/common.dart';
import 'package:ostinato/pages/student/common.dart';

class DetailStudentPage extends StatefulWidget {
  final String? studentId;
  const DetailStudentPage({super.key, this.studentId});

  @override
  State<DetailStudentPage> createState() => _DetailStudentPageState();
}

class _DetailStudentPageState extends State<DetailStudentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Student Detail",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            detailTitle(context, "Data"),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: detailItem(context, "Full name", "Cayleen"),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: detailItem(
                      context,
                      "Birth date",
                      DateFormat("dd MMMM yyyy")
                          .format(DateTime(2000, 12, 12))),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child:
                      detailItem(context, "E-mail address", "student@mail.com"),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: detailItem(context, "Phone number", "628172924920"),
                ),
              ],
            ),
            detailTitle(context, "Schedule"),
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  detailScheduleDate(context, DateTime(2024, 7, 1)),
                  Column(
                    children: [
                      detailStudentTime(context, "1",
                          DateTime(2024, 7, 1, 16, 0), "Cayleen", "Piano"),
                    ],
                  ),
                  detailScheduleDate(context, DateTime(2024, 7, 8)),
                  Column(
                    children: [
                      detailStudentTime(context, "1",
                          DateTime(2024, 7, 8, 16, 0), "Cayleen", "Piano"),
                    ],
                  ),
                  detailScheduleDate(context, DateTime(2024, 7, 15)),
                  Column(
                    children: [
                      detailStudentTime(context, "1",
                          DateTime(2024, 7, 15, 16, 0), "Cayleen", "Piano"),
                    ],
                  ),
                  detailScheduleDate(context, DateTime(2024, 7, 22)),
                  Column(
                    children: [
                      detailStudentTime(context, "1",
                          DateTime(2024, 7, 22, 16, 0), "Cayleen", "Piano"),
                    ],
                  ),
                  detailScheduleDate(context, DateTime(2024, 7, 29)),
                  Column(
                    children: [
                      detailStudentTime(context, "1",
                          DateTime(2024, 7, 29, 16, 0), "Cayleen", "Piano"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
