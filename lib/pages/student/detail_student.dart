import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/pages/schedule/form_schedule.dart';
import 'package:ostinato/pages/student/common.dart';
import 'package:ostinato/pages/student/form_student.dart';
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
    _studentDetail = StudentService().getStudentDetail(widget.studentId);
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
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('No student found'));
                }
                Student student = snapshot.data!.data;
                List<Schedule>? schedules = student.schedules;
                return Column(
                  children: [
                    detailTitle(
                      context,
                      "Data",
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.pencil,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FormStudentPage(
                                    studentId: student.id,
                                  )));
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child: detailItem(context, "Full name", student.name),
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
                      child:
                          detailItem(context, "E-mail address", student.email),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child: detailItem(
                          context, "Phone number", student.phoneNumber),
                    ),
                    detailTitle(
                      context,
                      "Schedule",
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.plus,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const FormSchedulePage(
                                  // studentId: student.id,
                                  )));
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
                              Schedule schedule = schedules[index];
                              return Column(
                                children: [
                                  detailScheduleDate(context, schedule.date),
                                  Column(
                                    children: [
                                      detailStudentTime(context, schedule),
                                    ],
                                  ),
                                ],
                              );
                            },
                          )
                  ],
                );
              },
            ),
            /* Container(
              padding: const EdgeInsets.only(bottom: 16),
              child: FutureBuilder(
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
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('No student found'));
                  }

                  Student student = snapshot.data!.data;
                  List<Schedule>? schedules = student.schedules;
                  return schedules == null
                      ? const Center(child: Text('No schedule found'))
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: schedules.length,
                          itemBuilder: (BuildContext context, int index) {
                            Schedule schedule = schedules[index];
                            return Column(
                              children: [
                                detailScheduleDate(context, schedule.date),
                                Column(
                                  children: [
                                    detailStudentTime(context, schedule),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                },
              ),
            ), */
          ],
        ),
      ),
    );
  }
}
