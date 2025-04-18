import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ostinato/common/components/buttons.dart';
import 'package:ostinato/common/components/theme_extension.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:toastification/toastification.dart';

class ItemBottomSheet extends StatelessWidget {
  final Widget child;

  const ItemBottomSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [Container(padding: padding16, color: Theme.of(context).bottomSheetTheme.backgroundColor, child: child)]);
  }
}

class ActionDialog extends StatelessWidget {
  final VoidCallback action;
  final String contentText;
  final String actionText;

  const ActionDialog({super.key, required this.action, required this.contentText, required this.actionText});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 0,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      insetPadding: EdgeInsets.zero,
      child: Container(
        padding: padding16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              contentText,
              textAlign: TextAlign.center,
            ),
            Padding(padding: padding16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StyledTextButton(
                    action: () {
                      Navigator.pop(context);
                    },
                    text: "Cancel"),
                SolidButton(action: action, text: actionText),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget listBottomSheet<T>(
    {required BuildContext context,
    required List<T> items,
    required String title,
    required Function(T) onItemSelected,
    required Widget Function(T) itemContentBuilder}) {
  return ItemBottomSheet(
    child: Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontStyle: FontStyle.italic),
        ),
        Padding(padding: padding16),
        SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                T item = items[index];
                return GestureDetector(
                  onTap: () {
                    onItemSelected(item);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black38))),
                    child: itemContentBuilder(item),
                  ),
                );
              }),
        )
      ],
    ),
  );
}

Widget inputDateTimePicker({
  required BuildContext context,
  required String title,
  String pickerType = 'date',
  required DateTime selectedTime,
  required Function setTime,
}) {
  assert(pickerType == 'date' || pickerType == 'time');
  DateFormat dateFormat;
  switch (pickerType) {
    case 'date':
      dateFormat = DateFormat('yyyy MM dd EEEE');
      break;
    case 'time':
      dateFormat = DateFormat('HH:mm');
      break;
    default:
      dateFormat = DateFormat('yyyy MM dd');
      break;
  }
  DateTime currentTime = DateTime.now();
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontStyle: FontStyle.italic),
      ),
      ScrollDateTimePicker(
        itemExtent: 48,
        visibleItem: 5,
        infiniteScroll: false,
        centerWidget: DateTimePickerCenterWidget(
          builder: (context, constraints, child) {
            return Container(
              margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              padding: padding8,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black, width: 1.0),
                  bottom: BorderSide(color: Colors.black, width: 1.0),
                  left: BorderSide(color: Colors.black, width: 6.0),
                ),
              ),
            );
          },
        ),
        dateOption: DateTimePickerOption(
          dateFormat: dateFormat,
          minDate: DateTime(currentTime.year - 100, 1),
          maxDate: DateTime(currentTime.year + 5, 12),
          initialDate: selectedTime.add(const Duration(hours: 1)),
        ),
        style: DateTimePickerStyle(activeStyle: const TextStyle(fontWeight: FontWeight.bold)),
        onChange: (time) {
          setTime(time);
        },
      ),
      Padding(padding: padding8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StyledTextButton(
              action: () {
                Navigator.pop(context);
              },
              text: "Cancel"),
          SolidButton(
              action: () {
                Navigator.pop(context);
              },
              text: "Apply"),
        ],
      ),
      Padding(padding: padding8),
    ],
  );
}

Widget listHeader({required BuildContext context, required Widget child}) {
  return Container(
      width: double.infinity,
      padding: padding8,
      decoration: BoxDecoration(color: Theme.of(context).extension<OstinatoThemeExtension>()!.headerBackgroundColor),
      child: child);
}

Container scheduleItem(DateTime currentTime, Schedule schedule, BuildContext context, Widget button) {
  DateTime startTime = DateFormat.Hm().parse(schedule.startTime);
  startTime = DateTime(schedule.date.year, schedule.date.month, schedule.date.day, startTime.hour, startTime.minute);
  DateTime endTime = DateFormat.Hm().parse(schedule.endTime);
  endTime = DateTime(schedule.date.year, schedule.date.month, schedule.date.day, endTime.hour, endTime.minute);
  bool isCurrentSchedule = (startTime.isBefore(currentTime) || currentTime == startTime) && (endTime.isAfter(currentTime) || currentTime == endTime);

  return Container(
    padding: isCurrentSchedule ? const EdgeInsets.fromLTRB(32, 4, 12, 4) : const EdgeInsets.fromLTRB(0, 4, 12, 4),
    margin: isCurrentSchedule ? EdgeInsets.zero : const EdgeInsets.only(left: 32),
    decoration: BoxDecoration(
        color: isCurrentSchedule ? Theme.of(context).extension<OstinatoThemeExtension>()!.scheduleHighlightColor : Colors.transparent,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).extension<OstinatoThemeExtension>()!.separatorColor),
        )),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.startTime,
                  style: TextStyle(fontWeight: FontWeight.bold, decoration: schedule.status == 'canceled' ? TextDecoration.lineThrough : TextDecoration.none),
                ),
                Text(
                  schedule.endTime,
                  style: Theme.of(context).textTheme.labelSmall!.merge(const TextStyle(color: Colors.grey)),
                )
              ],
            )),
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      schedule.student.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  rescheduleStatus(schedule.isRescheduled ?? false),
                  scheduleStatus(schedule.status),
                ],
              ),
              Text(
                schedule.instrument.name,
                style: Theme.of(context).textTheme.labelSmall!.merge(const TextStyle(color: Colors.grey)),
              ),
              schedule.scheduleNote != null
                  ? Container(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        schedule.scheduleNote!.note,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
        button
      ],
    ),
  );
}

Container eventItem(DateTime currentTime, NeatCleanCalendarEvent event, Schedule schedule, BuildContext context, Widget button) {
  DateTime startTime = DateFormat.Hm().parse(schedule.startTime);
  startTime = DateTime(schedule.date.year, schedule.date.month, schedule.date.day, startTime.hour, startTime.minute);
  DateTime endTime = DateFormat.Hm().parse(schedule.endTime);
  endTime = DateTime(schedule.date.year, schedule.date.month, schedule.date.day, endTime.hour, endTime.minute);
  bool isCurrentSchedule = (startTime.isBefore(currentTime) || currentTime == startTime) && (endTime.isAfter(currentTime) || currentTime == endTime);

  return Container(
    padding: const EdgeInsets.fromLTRB(32, 4, 12, 4),
    decoration: BoxDecoration(
        color: isCurrentSchedule ? Theme.of(context).extension<OstinatoThemeExtension>()!.scheduleHighlightColor : Colors.transparent,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).extension<OstinatoThemeExtension>()!.separatorColor),
        )),
    child: Row(
      children: [
        Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat("HH:mm").format(event.startTime),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat("HH:mm").format(event.endTime),
                  style: Theme.of(context).textTheme.labelSmall!.merge(const TextStyle(color: Colors.grey)),
                )
              ],
            )),
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    event.summary,
                  ),
                  rescheduleStatus(schedule.isRescheduled ?? false),
                  scheduleStatus(schedule.status),
                ],
              ),
              Text(
                event.description,
                style: Theme.of(context).textTheme.labelSmall!.merge(const TextStyle(color: Colors.grey)),
              ),
              schedule.scheduleNote != null
                  ? Container(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        schedule.scheduleNote!.note,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
        button
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
          LucideIcons.circleCheck,
          color: HexColor('#2ec27d'),
          size: 14,
        ),
      );
    case "canceled":
      return Container(
        padding: const EdgeInsets.only(left: 8),
        child: Icon(
          LucideIcons.circleX,
          color: HexColor('#c70e03'),
          size: 14,
        ),
      );
    default:
      return const SizedBox();
  }
}

Widget rescheduleStatus(bool status) {
  return status
      ? Container(
          padding: const EdgeInsets.only(left: 8),
          child: Icon(
            LucideIcons.refreshCw,
            color: HexColor('#ffba47'),
            size: 14,
          ),
        )
      : const SizedBox();
}

ToastificationItem toastNotification(String text) {
  return toastification.showCustom(
    alignment: Alignment.bottomCenter,
    autoCloseDuration: const Duration(seconds: 5),
    builder: (context, holder) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                padding: padding8,
                color: const Color.fromARGB(125, 60, 60, 60),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium!.merge(const TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
