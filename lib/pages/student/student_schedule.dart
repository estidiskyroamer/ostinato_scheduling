import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/schedule/common.dart';
import 'package:ostinato/pages/schedule/form_schedule.dart';

class StudentSchedulePage extends StatefulWidget {
  const StudentSchedulePage({super.key});

  @override
  State<StudentSchedulePage> createState() => _StudentSchedulePageState();
}

class _StudentSchedulePageState extends State<StudentSchedulePage> {
  @override
  Widget build(BuildContext context) {
    DateTime currentMonthTime = DateTime.now();
    DateTime nextMonthTime = DateTime(currentMonthTime.year,
        currentMonthTime.month + 1, currentMonthTime.day);
    String currentMonthName = DateFormat("MMMM yyyy").format(currentMonthTime);
    String nextMonthName = DateFormat("MMMM yyyy").format(nextMonthTime);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Student Schedule",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FormSchedulePage()));
              },
              icon: const Icon(FontAwesomeIcons.plus))
        ],
      ),
      body: SingleChildScrollView(
        padding: padding16,
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  scheduleDate(context, DateTime(2024, 7, 1)),
                  Column(
                    children: [
                      studentTime(context, "1", DateTime(2024, 7, 1, 16, 0),
                          "Cayleen", "Piano"),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  scheduleDate(context, DateTime(2024, 7, 8)),
                  Column(
                    children: [
                      studentTime(context, "1", DateTime(2024, 8, 1, 16, 0),
                          "Cayleen", "Piano"),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  scheduleDate(context, DateTime(2024, 7, 14)),
                  Column(
                    children: [
                      studentTime(context, "1", DateTime(2024, 7, 14, 16, 0),
                          "Cayleen", "Piano"),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  scheduleDate(context, DateTime(2024, 7, 21)),
                  Column(
                    children: [
                      studentTime(context, "1", DateTime(2024, 7, 21, 16, 0),
                          "Cayleen", "Piano"),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  scheduleDate(context, DateTime(2024, 7, 28)),
                  Column(
                    children: [
                      studentTime(context, "1", DateTime(2024, 7, 28, 16, 0),
                          "Cayleen", "Piano"),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
