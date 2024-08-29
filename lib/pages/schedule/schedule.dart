import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  late Future<GroupedSchedule?> _scheduleList;
  late DateTime currentTime;

  final ItemScrollController _scrollController = ItemScrollController();

  @override
  void initState() {
    currentTime = DateTime.now();
    _scheduleList = ScheduleService()
        .getGroupedSchedule(month: currentTime.month, year: currentTime.year);
    super.initState();
  }

  void scrollToDate(GroupedSchedule scheduleList) {
    int nearestIndex = -1;
    DateTime? nearestDate;
    DateTime targetDate = DateTime.now();

    // Iterate over the schedule dates to find the nearest date
    for (int i = 0; i < scheduleList.data.length; i++) {
      DateTime date = DateTime.parse(scheduleList.data.keys.elementAt(i));

      // Check for an exact match
      if (date.isAtSameMomentAs(targetDate)) {
        nearestIndex = i;
        nearestDate = date;
        break;
      }

      if (nearestDate == null ||
          (date.isBefore(targetDate) && date.isAfter(nearestDate))) {
        nearestIndex = i;
        nearestDate = date;
      }
    }

    if (nearestIndex != -1) {
      _scrollController.scrollTo(
        index: nearestIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
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
        _scheduleList = ScheduleService().getGroupedSchedule(
            month: currentTime.month, year: currentTime.year);
      });
    }
  }

  void updateSchedule(Schedule schedule, String status) {
    Schedule update = Schedule(
      id: schedule.id,
      studentId: schedule.studentId,
      studentName: schedule.studentName,
      teacherId: schedule.teacherId,
      teacherName: schedule.teacherName,
      instrumentId: schedule.instrumentId,
      instrumentName: schedule.instrumentName,
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

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  scrollToDate(scheduleList);
                });

                return ScrollablePositionedList.builder(
                  itemScrollController: _scrollController,
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
}
