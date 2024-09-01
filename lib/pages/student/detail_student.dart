import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/pages/schedule/common.dart';
import 'package:ostinato/pages/schedule/form_reschedule.dart';
import 'package:ostinato/pages/schedule/form_schedule.dart';
import 'package:ostinato/pages/student/common.dart';
import 'package:ostinato/pages/student/form_student.dart';
import 'package:ostinato/pages/student/form_student_schedule.dart';
import 'package:ostinato/services/schedule_service.dart';
import 'package:ostinato/services/student_service.dart';

class DetailStudentPage extends StatefulWidget {
  final Student student;
  const DetailStudentPage({super.key, required this.student});

  @override
  State<DetailStudentPage> createState() => _DetailStudentPageState();
}

class _DetailStudentPageState extends State<DetailStudentPage> {
  late Future<StudentDetail?> _studentDetail;
  late Future<ScheduleList?> _studentScheduleList;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    getStudentDetail();
    getScheduleList();
    super.initState();
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
        _studentScheduleList =
            StudentService().getStudentSchedule(widget.student.id!);
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

  void addSchedule(Student student) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => FormStudentSchedulePage(
                  student: student,
                )))
        .then((value) => getScheduleList());
  }

  void editSchedule(Schedule schedule, Student student) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Student Detail",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            detailTitle(
              context,
              "Data",
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.pencil,
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
              builder: (BuildContext context,
                  AsyncSnapshot<StudentDetail?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 6,
                      child: Config().loadingIndicator,
                    ),
                  );
                }
                if (snapshot.hasError) {
                  inspect(snapshot);
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('No student found'));
                }
                Student student = snapshot.data!.data;
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child:
                          detailItem(context, "Full name", student.user.name),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child: detailItem(context, "Birth date",
                          DateFormat("dd MMMM yyyy").format(student.birthDate)),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child: detailItem(context, "Address", student.address),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child: detailItem(
                          context, "E-mail address", student.user.email),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child: detailItem(
                          context, "Phone number", student.user.phoneNumber),
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
                  FontAwesomeIcons.plus,
                  size: 20,
                ),
                onPressed: () {
                  addSchedule(widget.student);
                },
              ),
            ),
            FutureBuilder(
                future: _studentScheduleList,
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
                  if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                    return const Center(child: Text('No schedule yet'));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  ScheduleList scheduleList = snapshot.data!;
                  return GroupedListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    controller: _scrollController,
                    elements: scheduleList.data,
                    groupBy: (schedule) => schedule.date,
                    groupSeparatorBuilder: (value) =>
                        scheduleDate(context, value),
                    itemBuilder: (context, schedule) {
                      return detailStudentTime(schedule, schedule.student);
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget detailStudentTime(Schedule schedule, Student student) {
    return scheduleItem(
      false,
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
                    editSchedule(schedule, student);
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
