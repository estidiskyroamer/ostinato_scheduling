import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ostinato/common/components/components.dart';
import 'package:ostinato/common/components/schedule_bottom_sheet.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/pages/schedule/common.dart';
import 'package:ostinato/pages/schedule/form_reschedule.dart';
import 'package:ostinato/pages/student/common/component.dart';
import 'package:ostinato/pages/student/form_student.dart';
import 'package:ostinato/pages/student/form_student_schedule.dart';
import 'package:ostinato/services/schedule_service.dart';
import 'package:ostinato/services/student_service.dart';

class DetailStudentPage extends StatefulWidget {
  final User student;
  const DetailStudentPage({super.key, required this.student});

  @override
  State<DetailStudentPage> createState() => _DetailStudentPageState();
}

class _DetailStudentPageState extends State<DetailStudentPage> {
  late Future<StudentDetail?> _studentDetail;
  late Future<ScheduleList?> _studentScheduleList;
  late DateTime currentTime;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    currentTime = DateTime.now();
    getStudentDetail();
    getScheduleList();
  }

  void getStudentDetail() {
    if (mounted) {
      setState(() {
        _studentDetail = StudentService().getStudentDetail(widget.student.id!);
      });
    }
  }

  void getScheduleList() {
    if (mounted) {
      setState(() {
        _studentScheduleList = StudentService().getStudentSchedule(month: currentTime.month, year: currentTime.year, id: widget.student.id!);
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
    ScheduleService().updateSchedule(update).then((value) {
      if (value) {
        getScheduleList();
      }
      Navigator.of(context).pop();
    });
  }

  void addSchedule(User student) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => FormStudentSchedulePage(
                  student: student,
                )))
        .then((value) => getScheduleList());
  }

  void editSchedule(Schedule schedule, User student) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => FormStudentSchedulePage(
              schedule: schedule,
              student: student,
            ),
          ),
        )
        .then((value) => getScheduleList());
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
        .then((value) => getScheduleList());
  }

  void deleteSchedule(Schedule schedule) async {
    ScheduleService().deleteSchedule(schedule).then((value) {
      if (value) {
        getScheduleList();
        Navigator.of(context).pop();
      }
    });
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
        getScheduleList();
      });
    }
  }

  void resetScheduleDate() {
    if (mounted) {
      setState(() {
        currentTime = DateTime.now();
        getScheduleList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Student Detail",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SizedBox(
        child: Column(
          children: [
            detailTitle(
              context,
              "Data",
              IconButton(
                icon: const Icon(
                  LucideIcons.squarePen,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => FormStudentPage(
                                student: widget.student,
                              )))
                      .then((value) {
                    getStudentDetail();
                  });
                },
              ),
            ),
            FutureBuilder(
              future: _studentDetail,
              builder: (BuildContext context, AsyncSnapshot<StudentDetail?> snapshot) {
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
                  return const Center(child: Text('No student found'));
                }
                User student = snapshot.data!.data;
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child: detailItem(context, "Full name", student.name),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child: detailItem(context, "Birth date", student.birthDate != null ? DateFormat("dd MMMM yyyy").format(student.birthDate!) : ''),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child: detailItem(context, "Address", student.address ?? ''),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child: detailItem(context, "E-mail address", student.email),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child: detailItem(context, "Phone number", student.phoneNumber),
                    ),
                  ],
                );
              },
            ),
            detailTitle(
              context,
              "Schedule",
              IconButton(
                icon: const Icon(
                  LucideIcons.plus,
                ),
                onPressed: () {
                  addSchedule(widget.student);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    changeScheduleDate('subtract');
                  },
                  icon: const Icon(
                    LucideIcons.chevronLeft,
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
                      LucideIcons.chevronRight,
                      size: 16,
                    )),
              ],
            ),
            Flexible(
              child: FutureBuilder(
                  future: _studentScheduleList,
                  builder: (BuildContext context, AsyncSnapshot<ScheduleList?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 6,
                          child: Config().loadingIndicator,
                        ),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                      return const Center(child: Text('No schedule yet'));
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    ScheduleList scheduleList = snapshot.data!;
                    return GroupedListView(
                      order: GroupedListOrder.DESC,
                      controller: _scrollController,
                      elements: scheduleList.data,
                      groupBy: (schedule) => schedule.date,
                      groupSeparatorBuilder: (value) => scheduleDate(context, value),
                      itemBuilder: (context, schedule) {
                        return scheduleItem(
                          currentTime,
                          schedule,
                          context,
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: const Icon(
                                LucideIcons.ellipsisVertical,
                                size: 16,
                              ),
                              onPressed: () {
                                showModalBottomSheet<void>(
                                    context: context,
                                    builder: (context) {
                                      return ScheduleBottomSheet(
                                        schedule: schedule,
                                        onChanged: getScheduleList,
                                        page: 'student',
                                      );
                                    });
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
