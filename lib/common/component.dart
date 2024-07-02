import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final double marginTop;
  final double marginBottom;
  final Color borderColor;
  final TextInputType inputType;

  const InputField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    this.marginTop = 6.0,
    this.marginBottom = 6.0,
    this.borderColor = Colors.black,
    this.inputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 6),
      margin: EdgeInsets.only(top: marginTop, bottom: marginBottom),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: borderColor, width: 1.0),
          bottom: BorderSide(color: borderColor, width: 1.0),
          left: BorderSide(color: borderColor, width: 6.0),
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          isDense: true,
          border: InputBorder.none,
        ),
        controller: textEditingController,
        keyboardType: inputType,
        obscureText: inputType == TextInputType.visiblePassword ? true : false,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
