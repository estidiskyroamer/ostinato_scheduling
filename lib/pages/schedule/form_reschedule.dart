import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/components/buttons.dart';
import 'package:ostinato/common/components/components.dart';
import 'package:ostinato/common/components/input_field.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/instrument.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/services/schedule_service.dart';

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

  late Student selectedStudent;
  late Instrument selectedInstrument;
  late Schedule selectedSchedule;

  DateTime currentTime = DateTime.now();
  bool isLoading = false;

  String? courseLength;
  late String repeat;

  @override
  void initState() {
    super.initState();
    setTeacher();
    setStudent();
    setInstrument();
    getSettings();
    setStartDate(widget.schedule!.date);
    setStartTime(DateFormat.Hm().parse(widget.schedule!.startTime));
    setEndTime(DateFormat.Hm().parse(widget.schedule!.endTime));
  }

  void getSettings() async {
    Map<String, String> settings = await LocalSettings.getSettings();
    setState(() {
      courseLength = settings['courseLength']!;
    });
  }

  void setTeacher() async {
    teacherNameController.text = widget.schedule!.teacher.name;
  }

  void setStudent() {
    studentNameController.text = widget.schedule!.student.name;
  }

  void setInstrument() {
    instrumentController.text = widget.schedule!.instrument.name;
  }

  void setStartDate(DateTime selectedDate) {
    if (mounted) {
      setState(() {
        selectedScheduleDate = selectedDate;
        dateController.text = DateFormat('dd MMMM yyyy').format(selectedScheduleDate);
      });
    }
  }

  void setStartTime(DateTime selectedDate) {
    if (mounted) {
      setState(() {
        selectedScheduleStartTime = selectedDate;
        startTimeController.text = DateFormat('HH:mm').format(selectedScheduleStartTime);
      });
      courseLength != null
          ? setEndTime(
              selectedDate.add(
                Duration(minutes: int.parse(courseLength!)),
              ),
            )
          : null;
    }
  }

  void setEndTime(DateTime selectedDate) {
    if (mounted) {
      setState(() {
        selectedScheduleEndTime = selectedDate;
        endTimeController.text = DateFormat('HH:mm').format(selectedScheduleEndTime);
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
      body: SingleChildScrollView(child: buildForm(context)),
    );
  }

  Widget buildForm(BuildContext context) {
    return Container(
      padding: padding16,
      child: Column(
        children: [
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
                  return ItemBottomSheet(
                      child: inputDateTimePicker(title: "Set Date", context: context, selectedTime: selectedScheduleDate, setTime: setStartDate));
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
                        return ItemBottomSheet(
                            child: inputDateTimePicker(
                                title: "Set Start Time", pickerType: 'time', context: context, selectedTime: selectedScheduleStartTime, setTime: setStartTime));
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
                        return ItemBottomSheet(
                            child: inputDateTimePicker(
                                title: "Set End Time", pickerType: 'time', context: context, selectedTime: selectedScheduleEndTime, setTime: setEndTime));
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
                    if (teacherNameController.text != '' &&
                        studentNameController.text != '' &&
                        instrumentController.text != '' &&
                        dateController.text != '' &&
                        startTimeController.text != '' &&
                        endTimeController.text != '') {
                      updateSchedule(context);
                    }
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
        isRescheduled: true,
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
