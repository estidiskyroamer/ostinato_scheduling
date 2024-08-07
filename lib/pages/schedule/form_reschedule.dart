import 'dart:developer';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';

class FormReschedulePage extends StatefulWidget {
  final String? scheduleId;
  const FormReschedulePage({super.key, this.scheduleId});

  @override
  State<FormReschedulePage> createState() => _FormReschedulePageState();
}

class _FormReschedulePageState extends State<FormReschedulePage> {
  TextEditingController studentNameController = TextEditingController();
  TextEditingController teacherNameController = TextEditingController();
  TextEditingController instrumentController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  DateTime selectedScheduleStartDate = DateTime.now();
  DateTime selectedScheduleStartTime = DateTime.now();
  DateTime selectedScheduleEndTime = DateTime.now();
  String pageTitle = "Reschedule";

  @override
  void initState() {
    super.initState();
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
                  image: const AssetImage('assets/images/schedule.jpeg')),
              Padding(padding: padding16),
              InputField(
                  isReadOnly: true,
                  textEditingController: teacherNameController,
                  hintText: "Teacher name"),
              InputField(
                  isReadOnly: true,
                  textEditingController: studentNameController,
                  hintText: "Student name"),
              InputField(
                  isReadOnly: true,
                  textEditingController: instrumentController,
                  hintText: "Instrument"),
              Padding(padding: padding8),
              InputField(
                textEditingController: dateController,
                hintText: "Start date",
                onTap: () async {
                  final result = await dateTimePicker(
                      context, "Start Date", selectedScheduleStartDate);
                  if (result != null) {
                    dateController.text =
                        DateFormat("EEEE, dd MMMM yyyy").format(result);
                    setStartDate(result);
                  }
                },
                isReadOnly: true,
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      textEditingController: startTimeController,
                      hintText: "Start time",
                      onTap: () async {
                        final result = await dateTimePicker(
                            context,
                            "Start Time",
                            selectedScheduleStartTime,
                            DateTimePickerType.time);
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
                        final result = await dateTimePicker(context, "End Time",
                            selectedScheduleEndTime, DateTimePickerType.time);
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
                  text: "Reschedule"),
            ],
          ),
        ),
      ),
    );
  }
}
