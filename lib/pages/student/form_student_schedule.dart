import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/components/buttons.dart';
import 'package:ostinato/common/components/components.dart';
import 'package:ostinato/common/components/input_field.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/instrument.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/services/instrument_service.dart';
import 'package:ostinato/services/schedule_service.dart';

class FormStudentSchedulePage extends StatefulWidget {
  final Schedule? schedule;
  final User student;
  const FormStudentSchedulePage(
      {super.key, this.schedule, required this.student});

  @override
  State<FormStudentSchedulePage> createState() =>
      _FormStudentSchedulePageState();
}

class _FormStudentSchedulePageState extends State<FormStudentSchedulePage> {
  TextEditingController studentNameController = TextEditingController();
  TextEditingController teacherNameController = TextEditingController();
  TextEditingController instrumentController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController repeatController = TextEditingController();

  DateTime selectedScheduleDate = DateTime.now();
  DateTime selectedScheduleStartTime = DateTime.now();
  DateTime selectedScheduleEndTime = DateTime.now();
  String pageTitle = "New Schedule";

  late User selectedStudent;
  late InstrumentList? _instrumentList;
  late Instrument selectedInstrument;
  late User selectedTeacher;

  late String courseLength;

  DateTime currentTime = DateTime.now();
  bool isLoading = false;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    setEdit();
    getTeacher();
    getStudent();
    getInstrumentList();
    getSettings();
  }

  void getTeacher() async {
    String? teacher = await Config().storage.read(key: 'teacher');
    if (teacher != null) {
      selectedTeacher = User.fromJson(jsonDecode(teacher));
    }
    teacherNameController.text = selectedTeacher.name;
  }

  void getStudent() async {
    if (mounted) {
      setState(() {
        selectedStudent = widget.student;
        studentNameController.text = selectedStudent.name;
      });
    }
  }

  void getInstrumentList() async {
    _instrumentList = await InstrumentService().getInstruments();
  }

  void getSettings() async {
    Map<String, String> settings = await Settings.getSettings();
    setState(() {
      courseLength = settings['courseLength']!;
      repeatController.text = settings['repeat']!;
    });
  }

  void setEdit() {
    if (mounted) {
      if (widget.schedule != null) {
        setState(() {
          pageTitle = "Edit Schedule";
          isEdit = true;
        });
      }
    }
  }

  void setStudent(User student) {
    if (mounted) {
      setState(() {
        selectedStudent = student;
        studentNameController.text = selectedStudent.name;
      });
    }
  }

  void setInstrument(Instrument instrument) {
    if (mounted) {
      setState(() {
        selectedInstrument = instrument;
        instrumentController.text = selectedInstrument.name;
      });
    }
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
        setEndTime(
          selectedDate.add(
            Duration(minutes: int.parse(courseLength)),
          ),
        );
      });
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
            onTap: () {
              showModalBottomSheet<void>(
                  context: context,
                  builder: (context) {
                    return listBottomSheet<Instrument>(
                      context: context,
                      items: _instrumentList!.data,
                      title: "Choose instrument",
                      onItemSelected: setInstrument,
                      itemContentBuilder: (Instrument instrument) =>
                          Text(instrument.name),
                    );
                  });
            },
          ),
          Padding(padding: padding8),
          InputField(
            textEditingController: dateController,
            hintText: "Start date",
            onTap: widget.schedule != null
                ? null
                : () async {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (context) {
                        return ItemBottomSheet(
                            child: inputDateTimePicker(
                                title: "Set Date",
                                context: context,
                                selectedTime: selectedScheduleDate,
                                setTime: setStartDate));
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
                  onTap: widget.schedule != null
                      ? null
                      : () async {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (context) {
                              return ItemBottomSheet(
                                  child: inputDateTimePicker(
                                      title: "Set Start Time",
                                      pickerType: 'time',
                                      context: context,
                                      selectedTime: selectedScheduleStartTime,
                                      setTime: setStartTime));
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
                  onTap: widget.schedule != null
                      ? null
                      : () async {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (context) {
                              return ItemBottomSheet(
                                  child: inputDateTimePicker(
                                      title: "Set End Time",
                                      pickerType: 'time',
                                      context: context,
                                      selectedTime: selectedScheduleEndTime,
                                      setTime: setEndTime));
                            },
                          );
                        },
                  isReadOnly: true,
                ),
              ),
            ],
          ),
          Padding(padding: padding8),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Repeat for"),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 7,
                  child: InputField(
                    textEditingController: repeatController,
                    hintText: "4",
                    inputType: TextInputType.number,
                  ),
                ),
                const Text("week(s)")
              ],
            ),
          ),
          Padding(padding: padding16),
          isLoading
              ? Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 6,
                    child: Config().loadingIndicator,
                  ),
                )
              : widget.schedule != null
                  ? SolidButton(
                      action: () {
                        Navigator.pop(context);
                      },
                      text: "Update")
                  : SolidButton(
                      action: () {
                        setState(() {
                          isLoading = true;
                        });
                        Schedule create = Schedule(
                            student: selectedStudent,
                            teacher: selectedTeacher,
                            instrument: selectedInstrument,
                            date: selectedScheduleDate,
                            startTime: DateFormat('HH:mm')
                                .format(selectedScheduleStartTime),
                            endTime: DateFormat('HH:mm')
                                .format(selectedScheduleEndTime));
                        ScheduleService()
                            .createSchedule(create,
                                repeat: repeatController.text)
                            .then((result) {
                          setState(() {
                            isLoading = false;
                          });
                          if (result) {
                            Navigator.pop(context, true);
                          }
                        });
                      },
                      text: "Add Schedule",
                    )
        ],
      ),
    );
  }
}
