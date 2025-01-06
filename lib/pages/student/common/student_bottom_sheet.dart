import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ostinato/common/components/buttons.dart';
import 'package:ostinato/common/components/component.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/pages/student/detail_student.dart';
import 'package:ostinato/pages/student/form_student.dart';
import 'package:ostinato/services/student_service.dart';
import 'package:ostinato/services/user_service.dart';
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

  void toggleActiveStudent(
      User student, int isActive, BuildContext context) async {
    User updatedStudent = User(
        id: student.id,
        name: student.name,
        email: student.email,
        phoneNumber: student.phoneNumber,
        address: student.address,
        birthDate: student.birthDate,
        password: student.password,
        roles: student.roles,
        companies: student.companies,
        isActive: isActive);
    Navigator.of(context).pop();
    UserService().updateUser(updatedStudent).then((value) {
      if (value != null) {
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
              activeToggleButton(context),
            ],
          ),
        ],
      ),
    );
  }

  RowIconButton activeToggleButton(BuildContext context) {
    return RowIconButton(
        onTap: () {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ActionDialog(
                action: () {
                  student.isActive == 1
                      ? toggleActiveStudent(student, 0, context)
                      : toggleActiveStudent(student, 1, context);
                  // deleteStudent(student, context);
                },
                contentText: student.isActive == 1
                    ? "Are you sure you want to deactivate ${student.name}?"
                    : "Are you sure you want to activate ${student.name}?",
                // "Are you sure you want to delete this data? Student: ${student.name}\nTheir schedules will also be removed.",
                actionText: "Delete",
              );
            },
          );
        },
        icon: student.isActive == 1
            ? FontAwesomeIcons.xmark
            : FontAwesomeIcons.check,
        label: student.isActive == 1 ? "Deactivate" : "Activate");
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
