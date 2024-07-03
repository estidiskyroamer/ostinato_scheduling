import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/schedule/common.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
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
          "Monthly Schedule",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        automaticallyImplyLeading: false,
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
                      studentTime(context, "1", DateTime(2024, 7, 1, 16, 30),
                          "Clarice", "Piano"),
                      studentTime(context, "1", DateTime(2024, 7, 1, 17, 0),
                          "Cayleen", "Violin"),
                      studentTime(context, "1", DateTime(2024, 7, 1, 18, 0),
                          "Velove", "Piano"),
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
                  scheduleDate(context, DateTime(2024, 7, 2)),
                  Column(
                    children: [
                      studentTime(context, "1", DateTime(2024, 7, 2, 8, 30),
                          "Sierra", "Piano"),
                      studentTime(context, "1", DateTime(2024, 7, 2, 10, 0),
                          "Felicia", "Piano"),
                      studentTime(context, "1", DateTime(2024, 7, 2, 10, 30),
                          "Octhania", "Violin"),
                      studentTime(context, "1", DateTime(2024, 7, 2, 11, 30),
                          "Susie", "Piano"),
                      studentTime(context, "1", DateTime(2024, 7, 2, 13, 0),
                          "Hikaru", "Piano"),
                      studentTime(context, "1", DateTime(2024, 7, 2, 14, 0),
                          "Damar", "Piano"),
                      studentTime(context, "1", DateTime(2024, 7, 2, 14, 30),
                          "Gian", "Piano"),
                      studentTime(context, "1", DateTime(2024, 7, 2, 16, 0),
                          "Andrea Taylor", "Piano"),
                      studentTime(context, "1", DateTime(2024, 7, 2, 17, 0),
                          "Jocelyn", "Piano"),
                      studentTime(context, "1", DateTime(2024, 7, 2, 17, 30),
                          "Erci", "Piano"),
                      studentTime(context, "1", DateTime(2024, 7, 2, 18, 30),
                          "Ben", "Piano"),
                      studentTime(context, "1", DateTime(2024, 7, 2, 19, 0),
                          "Alene", "Piano"),
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
                  scheduleDate(context, DateTime(2024, 7, 4)),
                  Column(
                    children: [
                      studentTime(context, "1", DateTime(2024, 7, 4, 14, 0),
                          "Yoshiko", "Violin"),
                      studentTime(context, "1", DateTime(2024, 7, 4, 16, 0),
                          "Natasha", "Piano"),
                      studentTime(context, "1", DateTime(2024, 7, 4, 17, 30),
                          "Given", "Piano"),
                      studentTime(context, "1", DateTime(2024, 7, 4, 18, 30),
                          "Kive", "Piano"),
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
                  scheduleDate(context, DateTime(2024, 7, 10)),
                  Column(
                    children: [
                      studentTime(context, "1", DateTime(2024, 7, 10, 12, 30),
                          "Abby", "Violin"),
                      studentTime(context, "1", DateTime(2024, 7, 10, 13, 30),
                          "Andrea Taylor", "Piano"),
                      studentTime(context, "1", DateTime(2024, 7, 10, 15, 30),
                          "Abel", "Piano"),
                      studentTime(context, "1", DateTime(2024, 7, 10, 16, 15),
                          "Vrilla", "Piano"),
                      studentTime(context, "1", DateTime(2024, 7, 10, 16, 45),
                          "Andra", "Piano"),
                      studentTime(context, "1", DateTime(2024, 7, 10, 18, 30),
                          "Keenan", "Piano"),
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
