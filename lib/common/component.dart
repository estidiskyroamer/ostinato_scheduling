import 'dart:developer';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/config.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';

class InputField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final double marginTop;
  final double marginBottom;
  final Color borderColor;
  final TextInputType inputType;
  final VoidCallback? onTap;
  final bool isReadOnly;
  final bool isPassword;
  final int maxLines;

  const InputField(
      {super.key,
      required this.textEditingController,
      required this.hintText,
      this.marginTop = 6.0,
      this.marginBottom = 6.0,
      this.borderColor = Colors.black,
      this.inputType = TextInputType.text,
      this.onTap,
      this.isReadOnly = false,
      this.isPassword = false,
      this.maxLines = 1});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 6),
      margin:
          EdgeInsets.only(top: widget.marginTop, bottom: widget.marginBottom),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: widget.borderColor, width: 1.0),
          bottom: BorderSide(color: widget.borderColor, width: 1.0),
          left: BorderSide(color: widget.borderColor, width: 6.0),
        ),
      ),
      child: TextField(
        onTap: widget.onTap,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontStyle: FontStyle.italic, color: Colors.black38),
          isDense: true,
          border: InputBorder.none,
        ),
        controller: widget.textEditingController,
        keyboardType: widget.inputType,
        obscureText: widget.isPassword,
        style: Theme.of(context).textTheme.bodyMedium,
        readOnly: widget.isReadOnly,
        maxLines: widget.maxLines,
      ),
    );
  }
}

class ItemBottomSheet extends StatelessWidget {
  final Widget child;

  const ItemBottomSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Container(padding: padding16, color: HexColor("#E6F2FF"), child: child)
    ]);
  }
}

class RowIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;

  const RowIconButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: padding16,
          margin: padding8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: HexColor("#D8E4F0"),
          ),
          child: Column(
            children: [
              Icon(icon),
              Padding(
                padding: padding4,
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SolidButton extends StatelessWidget {
  final VoidCallback action;
  final String text;

  const SolidButton({super.key, required this.action, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: Colors.black,
          shape: const LinearBorder(),
          padding: padding8),
      onPressed: action,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width / 3,
            maxWidth: MediaQuery.of(context).size.width),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final VoidCallback action;
  final String text;

  const OutlineButton({super.key, required this.action, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(
              side: BorderSide(width: 1.0, color: Colors.black)),
          padding: padding8),
      onPressed: action,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width / 3,
            maxWidth: MediaQuery.of(context).size.width),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .merge(const TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
}

class StyledTextButton extends StatelessWidget {
  final VoidCallback action;
  final String text;

  const StyledTextButton({super.key, required this.action, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: action,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width / 4,
            maxWidth: MediaQuery.of(context).size.width),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .merge(const TextStyle(color: Colors.black)),
        ),
      ),
    );
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
      backgroundColor: HexColor("#E6F2FF"),
      insetPadding: EdgeInsets.zero,
      child: Container(
        padding: padding16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(contentText),
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

Future<DateTime?> dateTimePicker(
    BuildContext context, String title, DateTime initialDate,
    [DateTimePickerType? pickerType]) {
  pickerType = pickerType ?? DateTimePickerType.date;
  return showBoardDateTimePicker(
    context: context,
    pickerType: pickerType,
    initialDate: initialDate,
    options: BoardDateTimeOptions(
        backgroundColor: HexColor("#E6F2FF"),
        foregroundColor: HexColor("#DFEBF8"),
        activeColor: HexColor("#DFEBF8"),
        activeTextColor: Colors.black,
        backgroundDecoration: BoxDecoration(borderRadius: BorderRadius.zero),
        showDateButton: false,
        startDayOfWeek: DateTime.sunday,
        pickerFormat: PickerFormat.ymd,
        boardTitle: title,
        boardTitleTextStyle: Theme.of(context).textTheme.titleSmall,
        pickerSubTitles: const BoardDateTimeItemTitles(
            year: "Year", month: "Month", day: "Date")),
  );
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
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
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
      dateFormat = DateFormat('yyyy MM dd');
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
          initialDate: selectedTime,
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
