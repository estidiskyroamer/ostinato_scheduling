import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/dashboard/common.dart';
import 'package:ostinato/pages/schedule/common.dart';
import 'package:ostinato/pages/student/common.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime currentDate = DateTime.now();
  String greeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) {
      return 'Good Morning';
    } else if (hour >= 11 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 22) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${greeting()}, Teacher",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: padding16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat("dd MMMM yyyy").format(currentDate),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    DateFormat("EEEE").format(currentDate),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.black45),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                dashboardTitle(context, "Currently Teaching"),
                dashboardStudentTime(context, "1", DateTime(2024, 7, 8, 17, 0),
                    "Cayleen", "Violin"),
              ],
            ),
            Padding(padding: padding8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                dashboardTitle(context, "Upcoming"),
                dashboardStudentTime(context, "1", DateTime(2024, 7, 8, 18, 0),
                    "Velove", "Piano"),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                dashboardTitle(context, "Previous"),
                dashboardStudentTime(context, "1", DateTime(2024, 7, 8, 16, 30),
                    "Clarice", "Piano"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
