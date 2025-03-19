import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/components/components.dart';
import 'package:ostinato/common/components/schedule_bottom_sheet.dart';
import 'package:ostinato/common/components/theme_extension.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/summary.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/pages/schedule/form_reschedule.dart';
import 'package:ostinato/pages/schedule/form_schedule.dart';
import 'package:ostinato/services/schedule_service.dart';
import 'package:ostinato/services/summary_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<ScheduleList?> _scheduleList;

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

  late Future<String?> _user;
  late Future<Summary?> _summary;

  @override
  void initState() {
    super.initState();
    _user = Config().storage.read(key: 'user');
    getCurrentSchedule();
    getSummary();
  }

  void getCurrentSchedule() {
    if (mounted) {
      setState(() {
        _scheduleList = ScheduleService().getScheduleList(
            month: currentDate.month,
            year: currentDate.year,
            day: currentDate.day);
      });
    }
  }

  void getSummary() {
    if (mounted) {
      setState(() {
        _summary = SummaryService().getSummary();
      });
    }
  }

  void updateSchedule(Schedule schedule, String status) {
    Schedule update = Schedule(
      id: schedule.id,
      student: schedule.student,
      teacher: schedule.teacher,
      instrument: schedule.instrument,
      date: schedule.date,
      status: status,
      startTime: schedule.startTime,
      endTime: schedule.endTime,
    );
    Navigator.of(context).pop();
    ScheduleService().updateSchedule(update).then((value) {
      if (value) {
        getCurrentSchedule();
      }
    });
  }

  void addSchedule(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const FormSchedulePage()))
        .then((value) => getCurrentSchedule());
  }

  void editSchedule(Schedule schedule) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => FormSchedulePage(
              schedule: schedule,
            ),
          ),
        )
        .then((value) => getCurrentSchedule());
  }

  void reschedule(Schedule schedule) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => FormReschedulePage(
              schedule: schedule,
            ),
          ),
        )
        .then((value) => getCurrentSchedule());
  }

  void deleteSchedule(Schedule schedule) async {
    Navigator.of(context).pop();
    ScheduleService().deleteSchedule(schedule).then((value) {
      if (value) {
        getCurrentSchedule();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getTitle(),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          listHeader(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text("Today's Schedule",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall! 
                        .copyWith(color: Theme.of(context).extension<OstinatoThemeExtension>()!.headerForegroundColor)),
                Padding(padding: padding4),
                Text(
                  DateFormat("EEEE, dd MMMM yyyy").format(currentDate),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
          Expanded(
              flex: 3,
              child: SizedBox(
                width: double.infinity,
                child: FutureBuilder(
                  future: _scheduleList,
                  builder: (BuildContext context,
                      AsyncSnapshot<ScheduleList?> snapshot) {
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
                    ScheduleList scheduleList = snapshot.data!;
                    List<Schedule> schedules = scheduleList.data;
                    if (schedules.isEmpty) {
                      return const Center(child: Text('No schedule yet'));
                    } else {
                      return RefreshIndicator(
                        color: Colors.black,
                        onRefresh: () async {
                          getCurrentSchedule();
                        },
                        child: ListView.builder(
                            itemCount: schedules.length,
                            itemBuilder: (BuildContext context, int index) {
                              Schedule schedule = schedules[index];
                              return studentTime(context, schedule);
                            }),
                      );
                    }
                  },
                ),
              )),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: padding16,
              child: FutureBuilder(
                future: _summary,
                builder:
                    (BuildContext context, AsyncSnapshot<Summary?> snapshot) {
                  if (!snapshot.hasData || snapshot.hasError) {
                    return const SizedBox();
                  }
                  CourseSummary courses = snapshot.data!.data.courseSummary;
                  return Column(
                    children: [
                      const Text('You have completed'),
                      Text(
                        courses.done.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Text('courses this month'),
                      Padding(padding: padding4),
                      Text(courses.done / (courses.noStatus + courses.done) >
                              0.7
                          ? 'Just ${courses.noStatus} courses to go, keep it up!'
                          : "You're doing great!"),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget studentTime(BuildContext context, Schedule schedule) {
    DateTime currentTime = DateTime.now();
    DateTime startTime = DateFormat('HH:mm').parse(schedule.startTime);
    startTime = DateTime(currentTime.year, currentTime.month, currentTime.day,
        startTime.hour, startTime.minute);
    DateTime endTime = DateFormat('HH:mm').parse(schedule.endTime);
    endTime = DateTime(currentTime.year, currentTime.month, currentTime.day,
        endTime.hour, endTime.minute);
    bool isCurrentSchedule =
        (startTime.isBefore(currentTime) || currentTime == startTime) &&
            (endTime.isAfter(currentTime) || currentTime == endTime);
    return scheduleItem(
      isCurrentSchedule,
      schedule,
      context,
      Expanded(
        flex: 1,
        child: IconButton(
          icon: const Icon(
            FontAwesomeIcons.ellipsisVertical,
            size: 16,
          ),
          visualDensity: VisualDensity.compact,
          onPressed: () {
            showModalBottomSheet<void>(
                context: context,
                builder: (context) {
                  return ScheduleBottomSheet(
                      schedule: schedule, onChanged: getCurrentSchedule);
                });
          },
        ),
      ),
    );
  }

  FutureBuilder<String?> getTitle() {
    return FutureBuilder(
      future: _user,
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.hasData) {
          var jsonData = jsonDecode(snapshot.data!);
          User user = User.fromJson(jsonData);
          return Text(
            "${greeting()}, ${user.name.split(' ')[0]}",
            style: Theme.of(context).textTheme.titleMedium,
          );
        }
        return Text(
          greeting(),
          style: Theme.of(context).textTheme.titleMedium,
        );
      },
    );
  }
}
