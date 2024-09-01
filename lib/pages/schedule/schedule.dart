import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/pages/schedule/common.dart';
import 'package:ostinato/pages/schedule/form_reschedule.dart';
import 'package:ostinato/pages/schedule/form_schedule.dart';
import 'package:ostinato/services/schedule_service.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late Future<ScheduleList?> _scheduleList;
  late DateTime currentTime;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    currentTime = DateTime.now();
    getSchedule();
    super.initState();
  }

  void changeScheduleDate(String operation) {
    Jiffy scheduleTime = Jiffy.parseFromDateTime(currentTime);
    switch (operation) {
      case 'add':
        scheduleTime = scheduleTime.add(months: 1);
        break;
      case 'subtract':
        scheduleTime = scheduleTime.subtract(months: 1);
        break;
      default:
        scheduleTime = scheduleTime.add(months: 1);
        break;
    }
    if (mounted) {
      setState(() {
        currentTime = scheduleTime.dateTime;
        getSchedule();
      });
    }
  }

  void resetScheduleDate() {
    if (mounted) {
      setState(() {
        currentTime = DateTime.now();
        getSchedule();
      });
    }
  }

  void getSchedule() {
    if (mounted) {
      setState(() {
        _scheduleList = ScheduleService()
            .getScheduleList(month: currentTime.month, year: currentTime.year);
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
        getSchedule();
      }
    });
  }

  void addSchedule(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const FormSchedulePage()))
        .then((value) => getSchedule());
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
        .then((value) => getSchedule());
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
        .then((value) => getSchedule());
  }

  void deleteSchedule(Schedule schedule) async {
    ScheduleService().deleteSchedule(schedule).then((value) {
      if (value) {
        getSchedule();
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  changeScheduleDate('subtract');
                },
                icon: const Icon(FontAwesomeIcons.chevronLeft)),
            GestureDetector(
              onDoubleTap: () {
                resetScheduleDate();
              },
              child: Text(
                DateFormat('MMMM yyyy').format(currentTime),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
                onPressed: () {
                  changeScheduleDate('add');
                },
                icon: const Icon(FontAwesomeIcons.chevronRight)),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                addSchedule(context);
              },
              icon: const Icon(FontAwesomeIcons.plus))
        ],
        automaticallyImplyLeading: false,
      ),
      body: SizedBox(
          height: double.infinity,
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
                return GroupedListView(
                  controller: _scrollController,
                  elements: scheduleList.data,
                  groupBy: (schedule) => schedule.date,
                  groupSeparatorBuilder: (value) =>
                      scheduleDate(context, value),
                  itemBuilder: (context, schedule) {
                    return studentTime(context, schedule);
                  },
                );
              })),
    );
  }

  Widget studentTime(BuildContext context, Schedule schedule) {
    DateTime currentTime = DateTime.now();
    DateTime startTime = DateFormat('HH:mm').parse(schedule.startTime);
    startTime = DateTime(schedule.date.year, schedule.date.month,
        schedule.date.day, startTime.hour, startTime.minute);
    DateTime endTime = DateFormat('HH:mm').parse(schedule.endTime);
    endTime = DateTime(schedule.date.year, schedule.date.month,
        schedule.date.day, endTime.hour, endTime.minute);
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
          icon: Icon(
            FontAwesomeIcons.ellipsisVertical,
            color: Colors.grey[700],
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
}
