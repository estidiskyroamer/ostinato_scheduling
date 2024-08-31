import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/pages/schedule/common.dart';
import 'package:ostinato/pages/schedule/form_reschedule.dart';
import 'package:ostinato/pages/schedule/form_schedule.dart';
import 'package:ostinato/services/schedule_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<ScheduleList?> _scheduleList;
  late Timer _timer;

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

  @override
  void initState() {
    _user = Config().storage.read(key: 'user');
    getCurrentSchedule();
    startTimer();
    super.initState();
  }

  void getCurrentSchedule() {
    if (mounted) {
      setState(() {
        _scheduleList = ScheduleService().getScheduleList(
            month: currentDate.month,
            year: currentDate.year,
            day: currentDate.day);
      });
      inspect(_scheduleList);
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
    ScheduleService().updateSchedule(update).then((value) {
      if (value) {
        getCurrentSchedule();
      }
      Navigator.of(context).pop();
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
    ScheduleService().deleteSchedule(schedule).then((value) {
      if (value) {
        getCurrentSchedule();
        Navigator.of(context).pop();
      }
    });
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: getTitle(),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            listHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Today's Schedule",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.black45)),
                  Text(
                    DateFormat("EEEE, dd MMMM yyyy").format(currentDate),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            FutureBuilder(
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
                inspect(snapshot);
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
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: schedules.length,
                      itemBuilder: (BuildContext context, int index) {
                        Schedule schedule = schedules[index];
                        return studentTime(context, schedule);
                      });
                }
              },
            )
          ],
        ),
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
            color: Colors.black54,
          ),
          onPressed: () {
            showModalBottomSheet<void>(
                context: context,
                builder: (context) {
                  return scheduleBottomSheet(context, schedule, () {
                    updateSchedule(schedule, 'done');
                  }, () {
                    reschedule(schedule);
                  }, () {
                    updateSchedule(schedule, 'canceled');
                  }, () {
                    editSchedule(schedule);
                  }, () {
                    deleteSchedule(schedule);
                  });
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
          "${greeting()}",
          style: Theme.of(context).textTheme.titleMedium,
        );
      },
    );
  }
}
