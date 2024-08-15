import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/pages/student/common.dart';
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

  @override
  void initState() {
    _studentList = StudentService().getStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Student List",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FormStudentPage()));
                },
                icon: const Icon(FontAwesomeIcons.plus))
          ],
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Container(
              padding: padding16,
              child: InputField(
                  textEditingController: searchController,
                  hintText: "Search by student name..."),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: padding16,
                child: FutureBuilder(
                  future: _studentList,
                  builder: (BuildContext context,
                      AsyncSnapshot<StudentList?> snapshot) {
                    inspect(snapshot);
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
                    if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                      return const Center(child: Text('No students yet'));
                    }
                    final students = snapshot.data!.data;
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: students.length,
                      itemBuilder: (BuildContext context, int index) {
                        Student student = students[index];
                        return studentItem(context, student);
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }
}
