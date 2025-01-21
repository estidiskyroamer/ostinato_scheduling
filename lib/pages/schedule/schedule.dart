import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ostinato/common/components/components.dart';
import 'package:ostinato/common/components/schedule_bottom_sheet.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/pages/schedule/common.dart';
import 'package:ostinato/pages/schedule/form_schedule.dart';
import 'package:ostinato/services/schedule_service.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with AutomaticKeepAliveClientMixin {
  late Future<ScheduleList?> _scheduleList;
  late DateTime currentTime;

  final GroupedItemScrollController _scrollController =
      GroupedItemScrollController();

  @override
  void initState() {
    super.initState();
    currentTime = DateTime.now();
    getSchedule();
  }

  @override
  bool get wantKeepAlive => true;

  void scrollToDate(ScheduleList scheduleList) {
    int nearestIndex = -1;
    DateTime? nearestDate;
    DateTime targetDate = DateTime.now();

    // Iterate over the schedule dates to find the nearest date
    for (int i = 0; i < scheduleList.data.length; i++) {
      DateTime date = scheduleList.data[i].date;

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
      _scrollController.jumpToElement(
          alignment: 0.05, automaticAlignment: false, identifier: nearestDate);
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
        _scheduleList = ScheduleService()
            .getScheduleList(month: currentTime.month, year: currentTime.year);
      });
    }
  }

  void addSchedule(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const FormSchedulePage()))
        .then((value) => getSchedule());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const TabBar(tabs: [
            Tab(
              text: "List view",
            ),
            Tab(
              text: "Calendar view",
            )
          ]),
          actions: [
            IconButton(
                onPressed: () {
                  addSchedule(context);
                },
                icon: const Icon(FontAwesomeIcons.plus))
          ],
          automaticallyImplyLeading: false,
        ),
        body: TabBarView(children: [
          scheduleListView(context),
          scheduleCalendarView(),
        ]),
      ),
    );
  }

  FutureBuilder<ScheduleList?> scheduleCalendarView() {
    return FutureBuilder(
        future: _scheduleList,
        builder: (BuildContext context, AsyncSnapshot<ScheduleList?> snapshot) {
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
          Map<NeatCleanCalendarEvent, Schedule> eventToScheduleMap = {};

          List<NeatCleanCalendarEvent> events = schedules.map((schedule) {
            DateTime startTime = DateTime(
              schedule.date.year,
              schedule.date.month,
              schedule.date.day,
              int.parse(schedule.startTime.split(':')[0]),
              int.parse(schedule.startTime.split(':')[1]),
            );

            DateTime endTime = DateTime(
              schedule.date.year,
              schedule.date.month,
              schedule.date.day,
              int.parse(schedule.endTime.split(':')[0]),
              int.parse(schedule.endTime.split(':')[1]),
            );

            Color eventColor = Colors.grey;

            if (schedule.isRescheduled == true) {
              eventColor = HexColor('#ffba47');
            }
            if (schedule.status == 'done') {
              eventColor = HexColor('#2ec27d');
            }
            if (schedule.status == 'canceled') {
              eventColor = HexColor('#c70e03');
            }

            NeatCleanCalendarEvent event = NeatCleanCalendarEvent(
                schedule.student.name,
                description: schedule.instrument.name,
                startTime: startTime,
                endTime: endTime,
                color: eventColor);
            eventToScheduleMap[event] = schedule;
            return event;
          }).toList();
          return Calendar(
            initialDate: currentTime,
            eventsList: events,
            eventListBuilder: (context, events) {
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    getSchedule();
                  },
                  child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      NeatCleanCalendarEvent event = events[index];
                      Schedule? schedule = eventToScheduleMap[event];
                      return eventItem(
                          event,
                          schedule!,
                          context,
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: const Icon(
                                FontAwesomeIcons.ellipsisVertical,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                showModalBottomSheet<void>(
                                    context: context,
                                    builder: (context) {
                                      return ScheduleBottomSheet(
                                          schedule: schedule,
                                          onChanged: getSchedule);
                                    });
                              },
                            ),
                          ));
                    },
                  ),
                ),
              );
            },
            locale: 'en_US',
            isExpandable: true,
            isExpanded: true,
            showEventListViewIcon: false,
            showEvents: true,
            hideTodayIcon: true,
            topRowIconColor: Colors.black,
            selectedColor: Colors.black,
            todayColor: Colors.black,
            selectedTodayColor: Colors.blueGrey,
            expandableDateFormat: "EEEE, dd MMMM yyyy",
            dayOfWeekStyle: Theme.of(context).textTheme.bodyMedium,
            displayMonthTextStyle: Theme.of(context).textTheme.titleMedium,
            onMonthChanged: (value) {
              setState(() {
                currentTime = value;
                getSchedule();
              });
            },
          );
        });
  }

  Column scheduleListView(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                changeScheduleDate('subtract');
              },
              icon: const Icon(
                FontAwesomeIcons.chevronLeft,
                size: 16,
              ),
            ),
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
                icon: const Icon(
                  FontAwesomeIcons.chevronRight,
                  size: 16,
                )),
          ],
        ),
        Expanded(
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  scrollToDate(scheduleList);
                });
                return RefreshIndicator(
                  color: Colors.black,
                  onRefresh: () async {
                    getSchedule();
                  },
                  child: StickyGroupedListView(
                      elements: scheduleList.data,
                      elementIdentifier: (schedule) => schedule.date,
                      itemScrollController: _scrollController,
                      itemComparator: (e1, e2) =>
                          e1.startTime.compareTo(e2.startTime),
                      groupBy: (schedule) => schedule.date,
                      groupSeparatorBuilder: (value) =>
                          scheduleDate(context, value.date),
                      itemBuilder: (context, schedule) {
                        return studentTime(context, schedule);
                      }),
                );
              }),
        ),
      ],
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
            color: Colors.black,
            size: 16,
          ),
          onPressed: () {
            showModalBottomSheet<void>(
                context: context,
                builder: (context) {
                  return ScheduleBottomSheet(
                      schedule: schedule, onChanged: getSchedule);
                });
          },
        ),
      ),
    );
  }
}
