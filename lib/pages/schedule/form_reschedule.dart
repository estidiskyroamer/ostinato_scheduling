import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/instrument.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/services/instrument_service.dart';
import 'package:ostinato/services/schedule_service.dart';
import 'package:ostinato/services/student_service.dart';

class FormReschedulePage extends StatefulWidget {
  final Schedule? schedule;
  const FormReschedulePage({super.key, this.schedule});

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

  late String? _teacherId;
  late String? _teacherName;
  late StudentList? _studentList;
  late Student selectedStudent;
  late InstrumentList? _instrumentList;
  late Instrument selectedInstrument;
  late Schedule selectedSchedule;

  DateTime currentTime = DateTime.now();
  bool isLoading = false;

  @override
  void initState() {
    setTeacher();
    setStudent();
    setInstrument();
    setStartDate(widget.schedule!.date);
    setStartTime(DateFormat.Hm().parse(widget.schedule!.startTime));
    setEndTime(DateFormat.Hm().parse(widget.schedule!.endTime));
    super.initState();
  }

  void setTeacher() async {
    teacherNameController.text = widget.schedule!.teacher.user.name;
  }

  void getStudentList() async {
    _studentList = await StudentService().getStudents();
  }

  void getInstrumentList() async {
    _instrumentList = await InstrumentService().getInstruments();
  }

  void setStudent() {
    studentNameController.text = widget.schedule!.student.user.name;
  }

  void setInstrument() {
    instrumentController.text = widget.schedule!.instrument.name;
  }

  void setStartDate(DateTime selectedDate) {
    if (mounted) {
      setState(() {
        selectedScheduleDate = selectedDate;
        dateController.text =
            DateFormat('dd MMMM yyyy').format(selectedScheduleDate);
      });
    }
  }

  void setStartTime(DateTime selectedDate) {
    if (mounted) {
      setState(() {
        selectedScheduleStartTime = selectedDate;
        startTimeController.text =
            DateFormat('HH:mm').format(selectedScheduleStartTime);
      });
      setEndTime(
        selectedDate.add(
          const Duration(minutes: 30),
        ),
      );
    }
  }

  void setEndTime(DateTime selectedDate) {
    if (mounted) {
      setState(() {
        selectedScheduleEndTime = selectedDate;
        endTimeController.text =
            DateFormat('HH:mm').format(selectedScheduleEndTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          pageTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(child: buildForm(context)),
    );
  }

  Widget buildForm(BuildContext context) {
    return Container(
      padding: padding16,
      child: Column(
        children: [
          Image(
              width: MediaQuery.sizeOf(context).width / 2,
              image: const AssetImage('assets/images/schedule.jpeg')),
          Padding(padding: padding16),
          InputField(
            textEditingController: teacherNameController,
            hintText: "Teacher name",
            isReadOnly: true,
          ),
          InputField(
            textEditingController: studentNameController,
            hintText: "Student name",
            isReadOnly: true,
          ),
          InputField(
            textEditingController: instrumentController,
            hintText: "Instrument",
            isReadOnly: true,
          ),
          Padding(padding: padding8),
          InputField(
            textEditingController: dateController,
            hintText: "Start date",
            onTap: () async {
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
                  onTap: () async {
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
                  onTap: () async {
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
          isLoading
              ? Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 6,
                    child: Config().loadingIndicator,
                  ),
                )
              : SolidButton(
                  action: () {
                    updateSchedule(context);
                  },
                  text: "Reschedule")
        ],
      ),
    );
  }

  void updateSchedule(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    Schedule update = Schedule(
        id: widget.schedule!.id,
        student: widget.schedule!.student,
        teacher: widget.schedule!.teacher,
        instrument: widget.schedule!.instrument,
        date: selectedScheduleDate,
        status: 'rescheduled',
        startTime: DateFormat('HH:mm').format(selectedScheduleStartTime),
        endTime: DateFormat('HH:mm').format(selectedScheduleEndTime));
    ScheduleService().updateSchedule(update).then((result) {
      setState(() {
        isLoading = false;
      });
      if (result) {
        Navigator.pop(context, true);
      }
    });
  }
}
