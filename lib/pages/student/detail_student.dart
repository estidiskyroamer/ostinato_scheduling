import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final String studentId;
  const DetailStudentPage({super.key, required this.studentId});

  @override
  State<DetailStudentPage> createState() => _DetailStudentPageState();
}

class _DetailStudentPageState extends State<DetailStudentPage> {
  late Future<StudentDetail?> _studentDetail;

  @override
  void initState() {
    super.initState();
    getStudentDetail();
  }

  void getStudentDetail() {
    if (mounted) {
      setState(() {
        _studentDetail = StudentService().getStudentDetail(widget.studentId);
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
        getStudentDetail();
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
        .then((value) => getStudentDetail());
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
        .then((value) => getStudentDetail());
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
        .then((value) => getStudentDetail());
  }

  void deleteSchedule(Schedule schedule) async {
    ScheduleService().deleteSchedule(schedule).then((value) {
      if (value) {
        getStudentDetail();
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
                Map<String, List<Schedule>>? schedules = student.schedules;
                return Column(
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
                                        student: student,
                                      )))
                              .then((value) {
                            setState(() {
                              _studentDetail = StudentService()
                                  .getStudentDetail(widget.studentId);
                            });
                          });
                        },
                      ),
                    ),
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
                    detailTitle(
                      context,
                      "Schedule",
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.plus,
                          size: 20,
                        ),
                        onPressed: () {
                          addSchedule(student);
                        },
                      ),
                    ),
                    schedules == null
                        ? const Center(child: Text('No schedule found'))
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: schedules.length,
                            itemBuilder: (BuildContext context, int index) {
                              DateTime date = DateTime.parse(
                                  schedules.keys.elementAt(index));
                              List<Schedule> scheduleList =
                                  schedules.values.elementAt(index);
                              return Column(
                                children: [
                                  detailScheduleDate(context, date),
                                  ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: scheduleList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Schedule schedule = scheduleList[index];
                                        return detailStudentTime(
                                            schedule, student);
                                      })
                                ],
                              );
                            },
                          )
                  ],
                );
              },
            ),
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
