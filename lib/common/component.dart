import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ostinato/common/config.dart';

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
            color: HexColor("#CDD9E5"),
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
          shape: LinearBorder(),
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
      style: TextButton.styleFrom(
          shape: const LinearBorder(
              side: BorderSide(width: 1.0, color: Colors.black),
              bottom: LinearBorderEdge(size: 1.0)),
          padding: padding16),
      onPressed: action,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width / 2,
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
        foregroundColor: HexColor("#CDD9E5"),
        activeColor: HexColor("#CDD9E5"),
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
