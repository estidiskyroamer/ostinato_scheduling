import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/pages/schedule/common.dart';
import 'package:ostinato/pages/schedule/form_schedule.dart';
import 'package:ostinato/pages/student/detail_student.dart';
import 'package:ostinato/pages/student/form_student.dart';

Widget bottomSheet(BuildContext context, Student student, Function editStudent,
    Function deleteStudent) {
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
            RowIconButton(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailStudentPage(
                            student: student,
                          )));
                },
                icon: FontAwesomeIcons.magnifyingGlass,
                label: "Detail"),
            RowIconButton(
                onTap: () {
                  Navigator.pop(context);
                  editStudent();
                },
                icon: FontAwesomeIcons.pencil,
                label: "Edit"),
            RowIconButton(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ActionDialog(
                        action: () {
                          deleteStudent();
                        },
                        contentText:
                            "Are you sure you want to delete this data?\nStudent: ${student.user.name}",
                        actionText: "Delete",
                      );
                    },
                  );
                },
                icon: FontAwesomeIcons.trash,
                label: "Delete"),
          ],
        ),
      ],
    ),
  );
}

Widget detailTitle(BuildContext context, String title, [Widget? action]) {
  return Container(
    padding: const EdgeInsets.only(left: 16, right: 16),
    margin: const EdgeInsets.only(top: 16),
    decoration: const BoxDecoration(color: Colors.black12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        action ?? const SizedBox()
      ],
    ),
  );
}

Widget detailItem(BuildContext context, String title, String content) {
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontStyle: FontStyle.italic),
        ),
      ),
      Expanded(
        flex: 2,
        child: Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    ],
  );
}

Widget detailScheduleDate(BuildContext context, DateTime date) {
  return listHeader(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat("dd MMMM yyyy").format(date),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(
          DateFormat("EEEE").format(date),
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: Colors.black45),
        )
      ],
    ),
  );
}

Widget detailBottomSheet(BuildContext context, Student student) {
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FormStudentPage(
                            student: student,
                          )));
                },
                icon: FontAwesomeIcons.pencil,
                label: "Edit"),
            RowIconButton(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FormSchedulePage(),
                    ),
                  );
                },
                icon: FontAwesomeIcons.calendarPlus,
                label: "Add Schedule"),
            RowIconButton(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ActionDialog(
                        action: () {
                          Navigator.pop(context);
                        },
                        contentText:
                            "Are you sure you want to delete this data?",
                        actionText: "Delete",
                      );
                    },
                  );
                },
                icon: FontAwesomeIcons.trash,
                label: "Delete"),
          ],
        ),
      ],
    ),
  );
}
