import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/components/buttons.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:toastification/toastification.dart';

class ItemBottomSheet extends StatelessWidget {
  final Widget child;

  const ItemBottomSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Container(
          padding: padding16,
          color: Theme.of(context).bottomSheetTheme.backgroundColor,
          child: child)
    ]);
  }
}

class ActionDialog extends StatelessWidget {
  final VoidCallback action;
  final String contentText;
  final String actionText;

  const ActionDialog(
      {super.key,
      required this.action,
      required this.contentText,
      required this.actionText});

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
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontStyle: FontStyle.italic),
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
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.black38))),
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
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontStyle: FontStyle.italic),
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
        style: DateTimePickerStyle(
            activeStyle: const TextStyle(fontWeight: FontWeight.bold)),
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

Widget listHeader({required Widget child}) {
  return Container(
      width: double.infinity,
      padding: padding12,
      decoration: const BoxDecoration(color: Colors.black12),
      child: child);
}

Container scheduleItem(bool isCurrentSchedule, Schedule schedule,
    BuildContext context, Widget button) {
  DateTime startTime = DateFormat.Hm().parse(schedule.startTime);
  DateTime endTime = DateFormat.Hm().parse(schedule.endTime);
  Duration diff = endTime.difference(startTime);
  return Container(
    padding: isCurrentSchedule
        ? const EdgeInsets.fromLTRB(32, 8, 16, 8)
        : const EdgeInsets.fromLTRB(0, 8, 16, 8),
    margin:
        isCurrentSchedule ? EdgeInsets.zero : const EdgeInsets.only(left: 32),
    decoration: BoxDecoration(
        color: isCurrentSchedule ? HexColor("#FFF0D4") : Colors.transparent,
        border: const Border(
          bottom: BorderSide(color: Colors.black38),
        )),
    child: Row(
      children: [
        Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.startTime,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: schedule.status == 'canceled'
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
                Text(
                  '${diff.inMinutes} minutes',
                  style: Theme.of(context).textTheme.labelSmall,
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
                    schedule.student.name,
                  ),
                  rescheduleStatus(schedule.isRescheduled ?? false),
                  scheduleStatus(schedule.status),
                ],
              ),
              Text(
                schedule.instrument.name,
                style: Theme.of(context).textTheme.labelSmall,
              )
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

Widget rescheduleStatus(bool status) {
  return status
      ? Container(
          padding: const EdgeInsets.only(left: 8),
          child: Icon(
            FontAwesomeIcons.rotate,
            color: HexColor('#ffba47'),
            size: 18,
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
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
