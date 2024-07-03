import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';

Widget bottomSheet(BuildContext context, String scheduleId) {
  return Wrap(
    children: [
      Container(
        padding: padding16,
        color: HexColor("#E6F2FF"),
        child: Column(
          children: [
            Text(
              "Status",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Row(
              children: [
                RowIconButton(
                    onTap: () {
                      print("done $scheduleId");
                    },
                    icon: FontAwesomeIcons.circleCheck,
                    label: "Done"),
                RowIconButton(
                    onTap: () {
                      print("reschedule $scheduleId");
                    },
                    icon: FontAwesomeIcons.rotate,
                    label: "Reschedule"),
                RowIconButton(
                    onTap: () {
                      print("cancel $scheduleId");
                    },
                    icon: FontAwesomeIcons.circleXmark,
                    label: "Canceled"),
              ],
            ),
            Padding(padding: padding8),
            Text(
              "Manage",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Row(
              children: [
                RowIconButton(
                    onTap: () {
                      print("note $scheduleId");
                    },
                    icon: FontAwesomeIcons.filePen,
                    label: "Add Note"),
                RowIconButton(
                    onTap: () {
                      print("edit $scheduleId");
                    },
                    icon: FontAwesomeIcons.pencil,
                    label: "Edit"),
                RowIconButton(
                    onTap: () {
                      print("remove $scheduleId");
                    },
                    icon: FontAwesomeIcons.trash,
                    label: "Remove"),
              ],
            )
          ],
        ),
      ),
    ],
  );
}

Widget studentTime(BuildContext context, String scheduleId, DateTime time,
    String studentName, String instrument) {
  return Container(
    padding: padding8,
    margin: const EdgeInsets.only(top: 8, left: 32),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black38)),
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

Widget scheduleDate(BuildContext context, DateTime date) {
  return Container(
    padding: padding8,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), color: Colors.black12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat("dd MMMM yyyy").format(date),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          DateFormat("EEEE").format(date),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.black45),
        )
      ],
    ),
  );
}
