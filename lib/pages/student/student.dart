import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/student/common.dart';
import 'package:ostinato/pages/student/new_student.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  TextEditingController searchController = TextEditingController();
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
                      builder: (context) => NewStudentPage()));
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
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      studentItem(context, "Cayleen"),
                      studentItem(context, "Clarice"),
                      studentItem(context, "Velove"),
                      studentItem(context, "Vrilla"),
                      studentItem(context, "Sierra"),
                      studentItem(context, "Susie"),
                      studentItem(context, "Hikaru"),
                      studentItem(context, "Damar"),
                      studentItem(context, "Gian"),
                      studentItem(context, "Andrea Taylor"),
                      studentItem(context, "Jocelyn"),
                      studentItem(context, "Felicia"),
                      studentItem(context, "Erci"),
                      studentItem(context, "Ben"),
                      studentItem(context, "Yoshiko"),
                      studentItem(context, "Natasha"),
                      studentItem(context, "Given"),
                    ],
                  )),
            )
          ],
        ));
  }
}
