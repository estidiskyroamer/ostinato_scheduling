import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/schedule/schedule.dart';
import 'package:ostinato/pages/student/edit_student.dart';
import 'package:ostinato/pages/student/student_schedule.dart';

Widget studentItem(BuildContext context, String name) {
  return Container(
    decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black38))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name),
        IconButton(
          icon: const Icon(
            FontAwesomeIcons.ellipsisVertical,
            color: Colors.black54,
          ),
          onPressed: () {
            showModalBottomSheet<void>(
                context: context,
                builder: (context) {
                  return bottomSheet(context, '1');
                });
          },
        ),
      ],
    ),
  );
}

Widget bottomSheet(BuildContext context, String studentId) {
  return ItemBottomSheet(
    child: Column(
      children: [
        Text(
          "Manage",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontStyle: FontStyle.italic),
        ),
        Row(
          children: [
            RowIconButton(
                onTap: () {
                  Navigator.pop(context);
                  print("done $studentId");
                },
                icon: FontAwesomeIcons.magnifyingGlass,
                label: "Detail"),
            RowIconButton(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditStudentPage()));
                },
                icon: FontAwesomeIcons.pencil,
                label: "Edit"),
            RowIconButton(
                onTap: () {
                  Navigator.pop(context);
                  print("cancel $studentId");
                },
                icon: FontAwesomeIcons.trash,
                label: "Delete"),
          ],
        ),
      ],
    ),
  );
}
