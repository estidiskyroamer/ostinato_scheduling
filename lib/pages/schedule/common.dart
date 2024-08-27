import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/schedule_note.dart';
import 'package:ostinato/pages/schedule/form_reschedule.dart';
import 'package:ostinato/pages/schedule/form_schedule.dart';
import 'package:ostinato/pages/schedule/schedule_note/form_schedule_note.dart';
import 'package:ostinato/pages/schedule/schedule_note/schedule_note.dart';
import 'package:ostinato/services/schedule_service.dart';

Widget scheduleBottomSheet(
    BuildContext context,
    Schedule schedule,
    Function done,
    Function rescheduled,
    Function canceled,
    Function editSchedule,
    Function deleteSchedule) {
  return ItemBottomSheet(
    child: Column(
      children: [
        schedule.status == 'done' || schedule.status == 'canceled'
            ? SizedBox()
            : Column(
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
                            String date = DateFormat("dd MMMM yyyy")
                                .format(schedule.date);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ActionDialog(
                                  action: () {
                                    done();
                                  },
                                  contentText:
                                      "Are you sure you want to mark this schedule as done?"
                                      "\n$date\n${schedule.startTime} - ${schedule.studentName} (${schedule.instrumentName})",
                                  actionText: "Mark as Done",
                                );
                              },
                            );
                          },
                          icon: FontAwesomeIcons.circleCheck,
                          label: "Done"),
                      RowIconButton(
                          onTap: () {
                            Navigator.of(context).pop();
                            rescheduled();
                          },
                          icon: FontAwesomeIcons.rotate,
                          label: "Reschedule"),
                      RowIconButton(
                          onTap: () {
                            Navigator.pop(context);
                            String date = DateFormat("dd MMMM yyyy")
                                .format(schedule.date);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ActionDialog(
                                  action: () {
                                    canceled();
                                  },
                                  contentText:
                                      "Are you sure you want to mark this schedule as canceled?"
                                      "\n$date\n${schedule.startTime} - ${schedule.studentName} (${schedule.instrumentName})",
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
                ],
              ),
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
                      builder: (context) => ScheduleNotePage(
                            schedule: schedule,
                          )));
                },
                icon: FontAwesomeIcons.file,
                label: "Notes"),
            schedule.status == 'canceled' || schedule.status == 'done'
                ? const SizedBox()
                : RowIconButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      editSchedule();
                    },
                    icon: FontAwesomeIcons.pencil,
                    label: "Edit"),
            RowIconButton(
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return ActionDialog(
                            action: () {
                              deleteSchedule();
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

Widget noteBottomSheet(BuildContext context, ScheduleNote scheduleNote,
    Function editScheduleNote, Function deleteScheduleNote) {
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
                  editScheduleNote();
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
                          deleteScheduleNote();
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

Widget scheduleStatus(String? status) {
  switch (status) {
    case "done":
      return Container(
        padding: const EdgeInsets.only(left: 8),
        child: Icon(
          FontAwesomeIcons.circleCheck,
          color: HexColor('#2ec27d'),
          size: 18,
        ),
      );
    case "rescheduled":
      return Container(
        padding: const EdgeInsets.only(left: 8),
        child: Icon(
          FontAwesomeIcons.rotate,
          color: HexColor('#ffba47'),
          size: 18,
        ),
      );
    case "canceled":
      return Container(
        padding: const EdgeInsets.only(left: 8),
        child: Icon(
          FontAwesomeIcons.circleXmark,
          color: HexColor('#c70e03'),
          size: 18,
        ),
      );
    default:
      return const SizedBox();
  }
}
