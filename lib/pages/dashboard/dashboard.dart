import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/teacher.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/pages/dashboard/common.dart';
import 'package:ostinato/pages/schedule/common.dart';
import 'package:ostinato/pages/student/common.dart';
import 'package:ostinato/services/teacher_service.dart';

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

  late Future<TeacherDetail?> _teacherDetail;
  late Future<String?> _user;

  @override
  void initState() {
    _teacherDetail = TeacherService().getTeacherDetail();
    _user = Config().storage.read(key: 'user');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: /* Text(
          "${greeting()}, Teacher",
          style: Theme.of(context).textTheme.titleMedium,
        ), */
            FutureBuilder(
          future: _user,
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 6,
                  child: Config().loadingIndicator,
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('No teacher found'));
            }
            var jsonData = jsonDecode(snapshot.data!);
            User user = User.fromJson(jsonData);
            return Text(
              "${greeting()}, ${user.name.split(' ')[0]}",
              style: Theme.of(context).textTheme.titleMedium,
            );
          },
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
