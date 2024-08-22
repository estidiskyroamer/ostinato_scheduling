import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/account/common.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime firstDayCurrentMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayCurrentMonth = DateTime(now.year, now.month + 1, 0);
    return Scaffold(
      appBar: AppBar(
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
                  Text("Teacher",
                      style: Theme.of(context).textTheme.titleMedium),
                  Text("Monthly Summary for Teacher",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .merge(const TextStyle(color: Colors.black))),
                  Padding(padding: padding4),
                  Text(
                      "Data ranged from ${DateFormat("dd MMMM yyyy").format(firstDayCurrentMonth)} to ${DateFormat("dd MMMM yyyy").format(lastDayCurrentMonth)}",
                      style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ),
            Column(
              children: [
                Padding(padding: padding16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    summaryItem(context, "30", "Total Students"),
                    summaryItem(context, "+5", "New Students"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    summaryItem(context, "-2", "Leaving Students"),
                    summaryItem(context, "27", "Continuing Students"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    summaryItem(context, "120", "Total Courses"),
                    summaryItem(context, "28", "Courses Done"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    summaryItem(context, "60", "Courses Not Started"),
                    summaryItem(context, "34", "Courses Not Updated"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    summaryItem(context, "3", "Courses Rescheduled"),
                    summaryItem(context, "5", "Courses Canceled"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
