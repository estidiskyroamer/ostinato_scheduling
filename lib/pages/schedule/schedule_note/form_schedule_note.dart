import 'dart:developer';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';

class FormScheduleNotePage extends StatefulWidget {
  final String? scheduleNoteId;
  const FormScheduleNotePage({super.key, this.scheduleNoteId});

  @override
  State<FormScheduleNotePage> createState() => _FormScheduleNotePageState();
}

class _FormScheduleNotePageState extends State<FormScheduleNotePage> {
  TextEditingController noteController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  String pageTitle = "New Note";

  @override
  void initState() {
    setEdit();
    super.initState();
  }

  void setEdit() {
    if (mounted) {
      if (widget.scheduleNoteId != null) {
        setState(() {
          pageTitle = "Edit Note";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: padding16,
          child: Column(
            children: [
              Image(
                  width: MediaQuery.sizeOf(context).width / 2,
                  image: const AssetImage('assets/images/notes.jpeg')),
              Padding(padding: padding16),
              InputField(
                  textEditingController: noteController,
                  maxLines: 7,
                  hintText: "Write notes on this lesson..."),
              Padding(padding: padding16),
              SolidButton(
                  action: () {
                    Navigator.pop(context);
                  },
                  text: "Save"),
            ],
          ),
        ),
      ),
    );
  }
}
