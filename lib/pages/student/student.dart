import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ostinato/common/components/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/pages/student/common/student_bottom_sheet.dart';
import 'package:ostinato/pages/student/form_student.dart';
import 'package:ostinato/services/student_service.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  TextEditingController searchController = TextEditingController();
  late Future<StudentList?> _studentList;
  int totalStudents = 0;

  @override
  void initState() {
    super.initState();
    getStudents();
  }

  void getStudents() {
    setState(() {
      _studentList = StudentService().getStudents();
    });
  }

  void addStudent(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const FormStudentPage()))
        .then((value) => getStudents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: getTitle(),
          actions: [
            IconButton(
                onPressed: () {
                  addStudent(context);
                },
                icon: const Icon(FontAwesomeIcons.plus))
          ],
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                width: double.infinity,
                child: FutureBuilder(
                  future: _studentList,
                  builder: (BuildContext context,
                      AsyncSnapshot<StudentList?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 6,
                          child: Config().loadingIndicator,
                        ),
                      );
                    }
                    inspect(snapshot);
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                      return const Center(child: Text('No students yet'));
                    }
                    final students = snapshot.data!.data;
                    return RefreshIndicator(
                      color: Colors.black,
                      onRefresh: () async {
                        getStudents();
                      },
                      child: ListView.builder(
                        itemCount: students.length,
                        itemBuilder: (BuildContext context, int index) {
                          Student student = students[index];
                          return studentItem(context, student);
                        },
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }

  FutureBuilder<StudentList?> getTitle() {
    return FutureBuilder(
      future: _studentList,
      builder: (BuildContext context, AsyncSnapshot<StudentList?> snapshot) {
        if (snapshot.hasData) {
          final students = snapshot.data!.data;
          return Text(
            "Student List (${students.length})",
            style: Theme.of(context).textTheme.titleMedium,
          );
        }
        return Text(
          "Student List",
          style: Theme.of(context).textTheme.titleMedium,
        );
      },
    );
  }

  Widget studentItem(BuildContext context, Student student) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black38))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(student.user.name),
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.ellipsisVertical,
              color: Colors.black,
            ),
            onPressed: () {
              showModalBottomSheet<void>(
                  context: context,
                  builder: (context) {
                    return StudentBottomSheet(
                        student: student, onChanged: getStudents);
                  });
            },
          ),
        ],
      ),
    );
  }
}
