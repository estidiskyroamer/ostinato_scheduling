import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/pages/schedule/common.dart';
import 'package:ostinato/pages/schedule/form_schedule.dart';
import 'package:ostinato/services/schedule_service.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late Future<GroupedSchedule?> _scheduleList;
  late DateTime currentTime;
  late DateTime nextMonthTime;
  late String currentMonthName;
  late String nextMonthName;

  @override
  void initState() {
    currentTime = DateTime.now();
    nextMonthTime =
        DateTime(currentTime.year, currentTime.month + 1, currentTime.day);
    currentMonthName = DateFormat("MMMM yyyy").format(currentTime);
    nextMonthName = DateFormat("MMMM yyyy").format(nextMonthTime);

    _scheduleList = ScheduleService()
        .getGroupedSchedule(month: currentTime.month, year: currentTime.year);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Monthly Schedule",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => const FormSchedulePage()))
                    .then((value) {
                  setState(() {});
                });
              },
              icon: const Icon(FontAwesomeIcons.plus))
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
              future: _scheduleList,
              builder: (BuildContext context,
                  AsyncSnapshot<GroupedSchedule?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 6,
                      child: Config().loadingIndicator,
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('No schedule yet'));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                GroupedSchedule scheduleList = snapshot.data!;
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: scheduleList.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    DateTime date =
                        DateTime.parse(scheduleList.data.keys.elementAt(index));
                    List<Schedule> schedules =
                        scheduleList.data.values.elementAt(index);
                    return Column(
                      children: [
                        scheduleDate(context, date),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: schedules.length,
                            itemBuilder: (BuildContext context, int index) {
                              Schedule schedule = schedules[index];
                              return studentTime(context, schedule);
                            })
                      ],
                    );
                  },
                );
              })),
    );
  }
}
