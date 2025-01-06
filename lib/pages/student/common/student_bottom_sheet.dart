import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ostinato/common/components/buttons.dart';
import 'package:ostinato/common/components/component.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/pages/student/detail_student.dart';
import 'package:ostinato/pages/student/form_student.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentBottomSheet extends StatelessWidget {
  final User student;
  final VoidCallback onChanged;
  const StudentBottomSheet(
      {super.key, required this.student, required this.onChanged});

  void editStudent(User student, BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => FormStudentPage(
                  student: student,
                )))
        .then((value) => onChanged());
  }

  void deleteStudent(User student, BuildContext context) async {
    Navigator.of(context).pop();
    /* StudentService().deleteStudent(student).then((value) {
      if (value) {
        onChanged();
      }
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return ItemBottomSheet(
      child: Column(
        children: [
          Text(
            "Manage ${student.name}",
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
                    "Are you sure you want to delete this data? Student: ${student.name}\nTheir schedules will also be removed.",
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
          launchUrl(Uri.parse("https://wa.me/${student.phoneNumber}"));
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
