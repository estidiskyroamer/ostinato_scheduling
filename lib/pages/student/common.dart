import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/schedule/schedule.dart';
import 'package:ostinato/pages/student/detail_student.dart';
import 'package:ostinato/pages/student/form_student.dart';
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DetailStudentPage(
                            studentId: "1",
                          )));
                },
                icon: FontAwesomeIcons.magnifyingGlass,
                label: "Detail"),
            RowIconButton(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const FormStudentPage(
                            studentId: "1",
                          )));
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
                          Navigator.pop(context);
                        },
                        contentText:
                            "Are you sure you want to delete this data?",
                        actionText: "Delete",
                      );
                    },
                  );
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

Widget detailTitle(BuildContext context, String title) {
  return Container(
    padding: padding16,
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
  return Container(
    padding: padding16,
    margin: const EdgeInsets.only(top: 16),
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

Widget detailStudentTime(BuildContext context, String scheduleId, DateTime time,
    String studentName, String instrument) {
  return Container(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
    margin: const EdgeInsets.only(bottom: 8, left: 32),
    decoration: const BoxDecoration(
        border: Border(
      bottom: BorderSide(color: Colors.black38),
    )),
    child: Row(
      children: [
        Expanded(
            flex: 2,
            child: Container(
              child: Text(
                DateFormat("HH:mm").format(time),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )),
        Expanded(flex: 6, child: Text("$studentName ($instrument)")),
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
                    return bottomSheet(context, scheduleId);
                  });
            },
          ),
        ),
      ],
    ),
  );
}
