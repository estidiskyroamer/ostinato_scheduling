import 'package:flutter/material.dart';
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
  DateTime selectedScheduleDate = DateTime.now();
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
        selectedScheduleDate = selectedDate;
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
                onTap: widget.scheduleId != null
                    ? null
                    : () async {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (context) {
                            return inputDateTimePicker(
                                title: "Set Date",
                                context: context,
                                selectedTime: selectedScheduleDate,
                                setTime: setStartDate);
                          },
                        );
                      },
                isReadOnly: true,
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      textEditingController: startTimeController,
                      hintText: "Start time",
                      onTap: widget.scheduleId != null
                          ? null
                          : () async {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (context) {
                                  return inputDateTimePicker(
                                      title: "Set Start Time",
                                      pickerType: 'time',
                                      context: context,
                                      selectedTime: selectedScheduleStartTime,
                                      setTime: setStartTime);
                                },
                              );
                            },
                      isReadOnly: true,
                    ),
                  ),
                  Padding(padding: padding8),
                  Expanded(
                    child: InputField(
                      textEditingController: endTimeController,
                      hintText: "End time",
                      onTap: widget.scheduleId != null
                          ? null
                          : () async {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (context) {
                                  return inputDateTimePicker(
                                      title: "Set End Time",
                                      pickerType: 'time',
                                      context: context,
                                      selectedTime: selectedScheduleEndTime,
                                      setTime: setEndTime);
                                },
                              );
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
