import 'dart:developer';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';

class NewStudentPage extends StatefulWidget {
  const NewStudentPage({super.key});

  @override
  State<NewStudentPage> createState() => _NewStudentPageState();
}

class _NewStudentPageState extends State<NewStudentPage> {
  TextEditingController studentNameController = TextEditingController();
  TextEditingController studentAddressController = TextEditingController();
  TextEditingController teacherNameController = TextEditingController();
  TextEditingController instrumentController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  DateTime studentBirthDate =
      DateTime.now().subtract(const Duration(days: 365 * 10));
  DateTime selectedScheduleStartDate = DateTime.now();
  DateTime selectedScheduleStartTime = DateTime.now();
  DateTime selectedScheduleEndTime = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void setBirthDate(DateTime selectedDate) {
    if (mounted) {
      setState(() {
        studentBirthDate = selectedDate;
      });
    }
  }

  void setStartDate(DateTime selectedDate) {
    if (mounted) {
      setState(() {
        selectedScheduleStartDate = selectedDate;
      });
    }
  }

  void setStartTime(DateTime selectedDate) {
    if (mounted) {
      setState(() {
        selectedScheduleStartTime = selectedDate;
      });
    }
  }

  void setEndTime(DateTime selectedDate) {
    if (mounted) {
      setState(() {
        selectedScheduleEndTime = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Student",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: padding16,
          child: Column(
            children: [
              InputField(
                  textEditingController: studentNameController,
                  hintText: "Student name"),
              InputField(
                textEditingController: dateController,
                hintText: "Birth date",
                onTap: () async {
                  final result = await dateTimePicker(
                      context, "Birth Date", studentBirthDate);
                  if (result != null) {
                    dateController.text =
                        DateFormat("dd MMMM yyyy").format(result);
                    setStartDate(result);
                  }
                },
                isReadOnly: true,
              ),
              InputField(
                  textEditingController: studentNameController,
                  hintText: "Student address"),
              Padding(padding: padding8),
              InputField(
                  textEditingController: instrumentController,
                  hintText: "Instrument"),
              InputField(
                  textEditingController: teacherNameController,
                  hintText: "Teacher name"),
              Padding(padding: padding8),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      textEditingController: startTimeController,
                      hintText: "Start time",
                      onTap: () async {
                        final result = await dateTimePicker(
                            context, "Start Time", selectedScheduleStartTime);
                        if (result != null) {
                          startTimeController.text =
                              DateFormat("HH:mm").format(result);
                          setStartTime(result);
                        }
                      },
                      isReadOnly: true,
                    ),
                  ),
                  Padding(padding: padding8),
                  Expanded(
                    child: InputField(
                      textEditingController: endTimeController,
                      hintText: "End time",
                      onTap: () async {
                        final result = await dateTimePicker(
                            context, "End Time", selectedScheduleEndTime);
                        if (result != null) {
                          endTimeController.text =
                              DateFormat("HH:mm").format(result);
                          setEndTime(result);
                        }
                      },
                      isReadOnly: true,
                    ),
                  ),
                ],
              ),
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
