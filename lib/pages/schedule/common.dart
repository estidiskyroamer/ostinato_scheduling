import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/schedule/form_schedule.dart';
import 'package:ostinato/pages/schedule/form_schedule_note.dart';
import 'package:ostinato/pages/schedule/schedule_notes.dart';

Widget bottomSheet(BuildContext context, String scheduleId) {
  return ItemBottomSheet(
    child: Column(
      children: [
        Text(
          "Status",
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
                  print("done $scheduleId");
                },
                icon: FontAwesomeIcons.circleCheck,
                label: "Done"),
            RowIconButton(
                onTap: () {
                  Navigator.pop(context);
                  print("reschedule $scheduleId");
                },
                icon: FontAwesomeIcons.rotate,
                label: "Reschedule"),
            RowIconButton(
                onTap: () {
                  Navigator.pop(context);
                  print("cancel $scheduleId");
                },
                icon: FontAwesomeIcons.circleXmark,
                label: "Canceled"),
          ],
        ),
        Padding(padding: padding8),
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
                      builder: (context) => const ScheduleNotesPage()));
                },
                icon: FontAwesomeIcons.file,
                label: "Notes"),
            RowIconButton(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const FormSchedulePage(
                            scheduleId: "1",
                          )));
                },
                icon: FontAwesomeIcons.pencil,
                label: "Edit"),
            RowIconButton(
                onTap: () {
                  Navigator.pop(context);
                  print("delete $scheduleId");
                },
                icon: FontAwesomeIcons.trash,
                label: "Delete"),
          ],
        )
      ],
    ),
  );
}

Widget noteBottomSheet(BuildContext context, String scheduleNoteId) {
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
                      builder: (context) => const FormScheduleNotePage(
                            scheduleNoteId: "1",
                          )));
                },
                icon: FontAwesomeIcons.pencil,
                label: "Edit"),
            RowIconButton(
                onTap: () {
                  Navigator.pop(context);
                  print("delete $scheduleNoteId");
                },
                icon: FontAwesomeIcons.trash,
                label: "Delete"),
          ],
        )
      ],
    ),
  );
}

Widget studentTime(BuildContext context, String scheduleId, DateTime time,
    String studentName, String instrument) {
  return Container(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
    margin: const EdgeInsets.only(top: 8, left: 32),
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

Widget scheduleDate(BuildContext context, DateTime date) {
  return Container(
    padding: padding16,
    margin: const EdgeInsets.only(top: 16),
    decoration: const BoxDecoration(color: Colors.black12),
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

Widget noteItem(BuildContext context, String scheduleNoteId, String note,
    DateTime createdAt) {
  return Container(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    margin: const EdgeInsets.only(top: 8, left: 32),
    decoration: const BoxDecoration(
        border: Border(
      bottom: BorderSide(color: Colors.black38),
    )),
    child: Row(
      children: [
        Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Text(
                    DateFormat("dd MMMM yyyy HH:mm").format(createdAt),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ],
            )),
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
                    return noteBottomSheet(context, scheduleNoteId);
                  });
            },
          ),
        ),
      ],
    ),
  );
}
