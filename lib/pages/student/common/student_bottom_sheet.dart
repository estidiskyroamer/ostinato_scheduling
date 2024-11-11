import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/components/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/pages/schedule/common.dart';
import 'package:ostinato/pages/schedule/form_schedule.dart';
import 'package:ostinato/pages/student/detail_student.dart';
import 'package:ostinato/pages/student/form_student.dart';
import 'package:ostinato/services/student_service.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentBottomSheet extends StatelessWidget {
  final Student student;
  final VoidCallback onChanged;
  const StudentBottomSheet(
      {super.key, required this.student, required this.onChanged});

  void editStudent(Student student, BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => FormStudentPage(
                  student: student,
                )))
        .then((value) => onChanged());
  }

  void deleteStudent(Student student, BuildContext context) async {
    Navigator.of(context).pop();
    StudentService().deleteStudent(student).then((value) {
      if (value) {
        onChanged();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ItemBottomSheet(
      child: Column(
        children: [
          Text(
            "Manage ${student.user.name}",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontStyle: FontStyle.italic),
          ),
          Row(
            children: [
              detailButton(context),
              contactButton(context),
              deleteButton(context),
            ],
          ),
        ],
      ),
    );
  }

  RowIconButton deleteButton(BuildContext context) {
    return RowIconButton(
        onTap: () {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ActionDialog(
                action: () {
                  deleteStudent(student, context);
                },
                contentText:
                    "Are you sure you want to delete this data? Student: ${student.user.name}\nTheir schedules will also be removed.",
                actionText: "Delete",
              );
            },
          );
        },
        icon: FontAwesomeIcons.trash,
        label: "Delete");
  }

  RowIconButton contactButton(BuildContext context) {
    return RowIconButton(
        onTap: () {
          Navigator.pop(context);
          launchUrl(Uri.parse("https://wa.me/${student.user.phoneNumber}"));
        },
        icon: FontAwesomeIcons.whatsapp,
        label: "Contact");
  }

  RowIconButton detailButton(BuildContext context) {
    return RowIconButton(
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailStudentPage(
                    student: student,
                  )));
        },
        icon: FontAwesomeIcons.magnifyingGlass,
        label: "Detail");
  }
}
