import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/components/buttons.dart';
import 'package:ostinato/common/components/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/pages/schedule/form_reschedule.dart';
import 'package:ostinato/pages/schedule/form_schedule.dart';
import 'package:ostinato/pages/schedule/schedule_note/schedule_note.dart';
import 'package:ostinato/services/schedule_service.dart';
import 'package:share_plus/share_plus.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final Schedule schedule;
  final VoidCallback onChanged;
  const ScheduleBottomSheet(
      {super.key, required this.schedule, required this.onChanged});

  @override
  State<StatefulWidget> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
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
        widget.onChanged();
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
        .then((value) => widget.onChanged());
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
        .then((value) => widget.onChanged());
  }

  void deleteSchedule(Schedule schedule, BuildContext context) async {
    Navigator.of(context).pop();
    ScheduleService().deleteSchedule(schedule).then((value) {
      if (value) {
        widget.onChanged();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ItemBottomSheet(
      child: Column(
        children: [
          widget.schedule.status == 'done' ||
                  widget.schedule.status == 'canceled'
              ? const SizedBox()
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
                        updateButton(context, 'done'),
                        rescheduleButton(context),
                        updateButton(context, 'canceled')
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
              notesButton(context),
              RowIconButton(
                  onTap: () {
                    Navigator.of(context).pop();
                    String date = DateFormat("EEEE, dd MMMM y")
                        .format(widget.schedule.date);
                    Share.share(
                        "Hi ${widget.schedule.student.name}, this is a reminder for your piano lesson scheduled on $date at ${widget.schedule.startTime}. If you need to reschedule, please let me know in advance.");
                  },
                  icon: FontAwesomeIcons.shareNodes,
                  label: "Share"),
              deleteButton(context),
            ],
          )
        ],
      ),
    );
  }

  RowIconButton deleteButton(BuildContext context) {
    return RowIconButton(
        onTap: () {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return ActionDialog(
                    action: () {
                      deleteSchedule(widget.schedule, context);
                    },
                    contentText: "Are you sure you want to delete this data?",
                    actionText: "Delete",
                  );
                },
              );
            },
          );
        },
        icon: FontAwesomeIcons.trash,
        label: "Delete");
  }

  RowIconButton notesButton(BuildContext context) {
    return RowIconButton(
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ScheduleNotePage(
                    schedule: widget.schedule,
                  )));
        },
        icon: FontAwesomeIcons.file,
        label: "Notes");
  }

  RowIconButton rescheduleButton(BuildContext context) {
    return RowIconButton(
        onTap: () {
          Navigator.of(context).pop();
          reschedule(widget.schedule, context);
        },
        icon: FontAwesomeIcons.rotate,
        label: "Reschedule");
  }

  RowIconButton updateButton(BuildContext context, String status) {
    return RowIconButton(
        onTap: () {
          Navigator.pop(context);
          String date = DateFormat("dd MMMM yyyy").format(widget.schedule.date);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ActionDialog(
                action: () {
                  updateSchedule(widget.schedule, status, context);
                },
                contentText:
                    "Are you sure you want to mark this schedule as $status?"
                    "\n$date\n${widget.schedule.startTime} - ${widget.schedule.student.name} (${widget.schedule.instrument.name})",
                actionText: "Mark as $status",
              );
            },
          );
        },
        icon: FontAwesomeIcons.circleCheck,
        label: status.capitalizeFirst());
  }
}
