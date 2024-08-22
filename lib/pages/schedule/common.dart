import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/pages/schedule/form_reschedule.dart';
import 'package:ostinato/pages/schedule/form_schedule.dart';
import 'package:ostinato/pages/schedule/schedule_note/form_schedule_note.dart';
import 'package:ostinato/pages/schedule/schedule_note/schedule_note.dart';
import 'package:ostinato/services/schedule_service.dart';

Widget scheduleBottomSheet(BuildContext context, Schedule schedule) {
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ActionDialog(
                        action: () {
                          Navigator.pop(context);
                        },
                        contentText:
                            "Are you sure you want to mark this schedule as done?",
                        actionText: "Mark as Done",
                      );
                    },
                  );
                },
                icon: FontAwesomeIcons.circleCheck,
                label: "Done"),
            RowIconButton(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ActionDialog(
                        action: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FormReschedulePage()));
                        },
                        contentText: "Are you sure you want to reschedule?",
                        actionText: "Reschedule",
                      );
                    },
                  );
                },
                icon: FontAwesomeIcons.rotate,
                label: "Reschedule"),
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
                            "Are you sure you want to mark this schedule as canceled?",
                        actionText: "Mark as Canceled",
                      );
                    },
                  );
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
                      builder: (context) => const ScheduleNotePage()));
                },
                icon: FontAwesomeIcons.file,
                label: "Notes"),
            RowIconButton(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FormSchedulePage(
                            scheduleId: schedule.id,
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
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return ActionDialog(
                            action: () {
                              ScheduleService()
                                  .deleteSchedule(schedule)
                                  .then((value) {
                                setState(
                                  () {},
                                );
                                Navigator.pop(context);
                              });
                            },
                            contentText:
                                "Are you sure you want to delete this data?",
                            actionText: "Delete",
                          );
                        },
                      );
                    },
                  );
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
        )
      ],
    ),
  );
}

Widget studentTime(BuildContext context, Schedule schedule) {
  return Container(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
    margin: const EdgeInsets.only(left: 32),
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
                schedule.startTime,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )),
        Expanded(
            flex: 6,
            child:
                Text("${schedule.studentName} (${schedule.instrumentName})")),
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
                    return scheduleBottomSheet(context, schedule);
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
