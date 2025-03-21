import 'package:flutter/material.dart';
import 'package:ostinato/common/components/theme_extension.dart';

class InputField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final double marginTop;
  final double marginBottom;
  final TextInputType inputType;
  final TextCapitalization capitalization;
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
      this.inputType = TextInputType.text,
      this.capitalization = TextCapitalization.words,
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
          top: BorderSide(color: Theme.of(context).extension<OstinatoThemeExtension>()!.borderColor, width: 0.8),
          bottom: BorderSide(color: Theme.of(context).extension<OstinatoThemeExtension>()!.borderColor, width: 0.8),
          left: BorderSide(color: Theme.of(context).extension<OstinatoThemeExtension>()!.borderColor, width: 6.0),
        ),
      ),
      child: TextField(
        onTap: widget.onTap,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontStyle: FontStyle.italic, color:  Theme.of(context).extension<OstinatoThemeExtension>()!.inputHintColor),
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

class SmallInputField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final double marginTop;
  final double marginBottom;
  final TextInputType inputType;
  final TextCapitalization capitalization;
  final VoidCallback? onTap;
  final bool isReadOnly;
  final bool isPassword;
  final int maxLines;

  const SmallInputField(
      {super.key,
      required this.textEditingController,
      required this.hintText,
      this.marginTop = 6.0,
      this.marginBottom = 6.0,
      this.inputType = TextInputType.text,
      this.capitalization = TextCapitalization.words,
      this.onTap,
      this.isReadOnly = false,
      this.isPassword = false,
      this.maxLines = 1});

  @override
  State<SmallInputField> createState() => _SmallInputFieldState();
}

class _SmallInputFieldState extends State<SmallInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 6),
      width: MediaQuery.of(context).size.width / 8,
      margin:
          EdgeInsets.only(top: widget.marginTop, bottom: widget.marginBottom),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).extension<OstinatoThemeExtension>()!.borderColor, width: 0.8),
          bottom: BorderSide(color: Theme.of(context).extension<OstinatoThemeExtension>()!.borderColor, width: 0.8),
          left: BorderSide(color: Theme.of(context).extension<OstinatoThemeExtension>()!.borderColor, width: 6.0),
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
