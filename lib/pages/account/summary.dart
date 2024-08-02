import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ostinato/common/component.dart';
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
                          .displaySmall!
                          .merge(const TextStyle(color: Colors.black))),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    summaryItem(context, "30", "Total Students"),
                    summaryItem(context, "+5", "New Students"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    summaryItem(context, "-2", "Leaving Students"),
                    summaryItem(context, "27", "Continuing Students"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    summaryItem(context, "120", "Total Courses"),
                    summaryItem(context, "28", "Courses Done"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    summaryItem(context, "60", "Courses Not Started"),
                    summaryItem(context, "34", "Courses Not Updated"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
