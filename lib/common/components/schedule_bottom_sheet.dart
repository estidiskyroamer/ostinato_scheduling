import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ostinato/common/components/buttons.dart';
import 'package:ostinato/common/components/components.dart';
import 'package:ostinato/common/components/theme_extension.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/pages/schedule/form_reschedule.dart';
import 'package:ostinato/pages/schedule/form_schedule.dart';
import 'package:ostinato/pages/schedule/schedule_note/schedule_note.dart';
import 'package:ostinato/pages/student/detail_student.dart';
import 'package:ostinato/services/schedule_service.dart';
import 'package:share_plus/share_plus.dart';

class ScheduleBottomSheet extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback onChanged;
  final String page;
  const ScheduleBottomSheet({super.key, required this.schedule, required this.onChanged, required this.page});

  void updateSchedule(Schedule schedule, String status, BuildContext context) {
    Schedule update = Schedule(
      id: schedule.id,
      student: schedule.student,
      teacher: schedule.teacher,
      instrument: schedule.instrument,
      date: schedule.date,
      status: status,
      startTime: schedule.startTime,
      endTime: schedule.endTime,
    );
    Navigator.of(context).pop();
    ScheduleService().updateSchedule(update).then((value) {
      if (value) {
        onChanged();
      }
    });
  }

  void editSchedule(Schedule schedule, BuildContext context) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => FormSchedulePage(
              schedule: schedule,
            ),
          ),
        )
        .then((value) => onChanged());
  }

  void reschedule(Schedule schedule, BuildContext context) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => FormReschedulePage(
              schedule: schedule,
            ),
          ),
        )
        .then((value) => onChanged());
  }

  void deleteSchedule(Schedule schedule, BuildContext context) async {
    Navigator.of(context).pop();
    ScheduleService().deleteSchedule(schedule).then((value) {
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
          schedule.status == 'done' || schedule.status == 'canceled'
              ? const SizedBox()
              : Column(
                  children: [
                    Text(
                      "Status",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontStyle: FontStyle.italic),
                    ),
                    Row(
                      children: [updateButton(context, 'done'), rescheduleButton(context), updateButton(context, 'canceled')],
                    ),
                    Padding(padding: padding8),
                  ],
                ),
          Text(
            "Manage",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontStyle: FontStyle.italic),
          ),
          Row(
            children: [
              notesButton(context),
              RowIconButton(
                  onTap: () {
                    Navigator.of(context).pop();
                    String date = DateFormat("EEEE, dd MMMM y").format(schedule.date);
                    Share.share(
                        "Hi ${schedule.student.name}, this is a reminder for your piano lesson scheduled on $date at ${schedule.startTime}. If you need to reschedule, please let me know in advance.");
                  },
                  icon: LucideIcons.share2,
                  label: "Share"),
              page == 'schedule'
                  ? RowIconButton(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailStudentPage(
                              student: schedule.student,
                            ),
                          ),
                        );
                      },
                      icon: LucideIcons.search,
                      label: "View Student",
                    )
                  : deleteButton(context),
            ],
          ),
        ],
      ),
    );
  }

  RowIconButton deleteButton(BuildContext context) {
    return RowIconButton(
        onTap: () {
          Navigator.of(context).pop();
          String date = DateFormat("dd MMMM yyyy").format(schedule.date);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return ActionDialog(
                    action: () {
                      deleteSchedule(schedule, context);
                    },
                    contentText: "Are you sure you want to delete this data?"
                        "\n$date\n${schedule.startTime} - ${schedule.student.name} (${schedule.instrument.name})",
                    actionText: "Delete",
                  );
                },
              );
            },
          );
        },
        color: Theme.of(context).extension<OstinatoThemeExtension>()!.dangerColor,
        icon: LucideIcons.trash,
        label: "Delete");
  }

  RowIconButton notesButton(BuildContext context) {
    return RowIconButton(
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ScheduleNotePage(
                    schedule: schedule,
                  )));
        },
        icon: LucideIcons.notebookText,
        label: "Notes");
  }

  RowIconButton rescheduleButton(BuildContext context) {
    return RowIconButton(
        onTap: () {
          Navigator.of(context).pop();
          reschedule(schedule, context);
        },
        icon: LucideIcons.refreshCw,
        label: "Reschedule");
  }

  RowIconButton updateButton(BuildContext context, String status) {
    return RowIconButton(
        onTap: () {
          Navigator.pop(context);
          String date = DateFormat("dd MMMM yyyy").format(schedule.date);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ActionDialog(
                action: () {
                  updateSchedule(schedule, status, context);
                },
                contentText: "Are you sure you want to mark this schedule as $status?"
                    "\n$date\n${schedule.startTime} - ${schedule.student.name} (${schedule.instrument.name})",
                actionText: "Mark as $status",
              );
            },
          );
        },
        icon: status == 'done'
            ? LucideIcons.circleCheck
            : status == 'canceled'
                ? LucideIcons.circleX
                : LucideIcons.circle,
        label: status.capitalizeFirst());
  }
}
