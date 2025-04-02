import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/components/buttons.dart';
import 'package:ostinato/common/components/components.dart';
import 'package:ostinato/common/components/input_field.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/instrument.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/settings.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/services/instrument_service.dart';
import 'package:ostinato/services/schedule_service.dart';
import 'package:ostinato/services/settings_service.dart';
import 'package:ostinato/services/student_service.dart';

class FormSchedulePage extends StatefulWidget {
  final Schedule? schedule;
  const FormSchedulePage({super.key, this.schedule});

  @override
  State<FormSchedulePage> createState() => _FormSchedulePageState();
}

class _FormSchedulePageState extends State<FormSchedulePage> {
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

  late StudentList? _studentList;
  late User selectedStudent;
  late InstrumentList? _instrumentList;
  late Instrument selectedInstrument;
  late Schedule selectedSchedule;
  late User selectedTeacher;

  late String courseLength;

  DateTime currentTime = DateTime.now();
  bool isLoading = false;
  bool isStudentLoading = false;
  bool isInstrumentLoading = false;
  bool isEditSchedule = false;

  @override
  void initState() {
    super.initState();
    setEdit();
    getTeacher();
    getStudentList();
    getInstrumentList();
    getSettings();
  }

  void getTeacher() {
    Config().storage.read(key: 'teacher').then((value) {
      selectedTeacher = User.fromJson(jsonDecode(value!));
      teacherNameController.text = selectedTeacher.name;
    });
    //if (teacher != null) {

    //}
  }

  void getStudentList() async {
    setState(() {
      isStudentLoading = true;
    });
    _studentList = await StudentService().getStudents(1);
    setState(() {
      isStudentLoading = false;
    });
  }

  void getInstrumentList() async {
    setState(() {
      isInstrumentLoading = true;
    });
    _instrumentList = await InstrumentService().getInstruments();
    setState(() {
      isInstrumentLoading = false;
    });
  }

  void getSettings() async {
    ScheduleSettings? settings = await SettingsService().loadScheduleSettings();
    if (settings != null) {
      setState(() {
        courseLength = settings.lessonLength;
        repeatController.text = settings.repeat;
      });
    }
  }

  void setEdit() async {
    if (widget.schedule != null) {
      if (mounted) {
        setState(() {
          pageTitle = "Edit Schedule";
          isLoading = true;
          isEditSchedule = true;
        });
      }
      StudentDetail? studentDetail = await StudentService().getStudentDetail(widget.schedule!.student.id!);
      if (studentDetail != null) {
        setStudent(studentDetail.data);
        setStartDate(widget.schedule!.date);
        setStartTime(DateFormat.Hm().parse(widget.schedule!.startTime));
        setEndTime(DateFormat.Hm().parse(widget.schedule!.endTime));
        setState(() {
          isLoading = false;
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
      setEndTime(
        selectedDate.add(
          Duration(minutes: int.parse(courseLength)),
        ),
      );
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
            onTap: () {
              isStudentLoading || isEditSchedule
                  ? null
                  : showModalBottomSheet<void>(
                      context: context,
                      builder: (context) {
                        return listBottomSheet<User>(
                          context: context,
                          items: _studentList!.data,
                          title: "Set student",
                          onItemSelected: setStudent,
                          itemContentBuilder: (User student) => Text(student.name),
                        );
                      });
            },
          ),
          InputField(
            textEditingController: instrumentController,
            hintText: "Instrument",
            isReadOnly: true,
            onTap: () {
              isInstrumentLoading
                  ? null
                  : showModalBottomSheet<void>(
                      context: context,
                      builder: (context) {
                        return listBottomSheet<Instrument>(
                          context: context,
                          items: _instrumentList!.data,
                          title: "Choose instrument",
                          onItemSelected: setInstrument,
                          itemContentBuilder: (Instrument instrument) => Text(instrument.name),
                        );
                      });
            },
          ),
          Padding(padding: padding8),
          InputField(
            textEditingController: dateController,
            hintText: "Start date",
            onTap: isEditSchedule
                ? null
                : () async {
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
                  onTap: isEditSchedule
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
                  onTap: isEditSchedule
                      ? null
                      : () async {
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
          Padding(padding: padding8),
          isEditSchedule
              ? const SizedBox()
              : SizedBox(
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
              : isEditSchedule
                  ? SolidButton(
                      action: () {
                        if (teacherNameController.text != '' &&
                            studentNameController.text != '' &&
                            instrumentController.text != '' &&
                            dateController.text != '' &&
                            startTimeController.text != '' &&
                            endTimeController.text != '') {
                          updateSchedule(context);
                        } else {
                          null;
                        }
                      },
                      text: "Update")
                  : SolidButton(
                      action: () {
                        if (teacherNameController.text != '' &&
                            studentNameController.text != '' &&
                            instrumentController.text != '' &&
                            dateController.text != '' &&
                            startTimeController.text != '' &&
                            endTimeController.text != '') {
                          createSchedule(context);
                        } else {
                          null;
                        }
                      },
                      text: "Add Schedule",
                    )
        ],
      ),
    );
  }

  void createSchedule(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    Schedule create = Schedule(
        student: selectedStudent,
        teacher: selectedTeacher,
        instrument: selectedInstrument,
        date: selectedScheduleDate,
        startTime: DateFormat('HH:mm').format(selectedScheduleStartTime),
        endTime: DateFormat('HH:mm').format(selectedScheduleEndTime));
    ScheduleService().createSchedule(create, repeat: repeatController.text).then((result) {
      setState(() {
        isLoading = false;
      });
      if (result) {
        Navigator.pop(context, true);
      }
    });
  }

  void updateSchedule(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    Schedule update = Schedule(
        id: widget.schedule!.id,
        student: selectedStudent,
        teacher: selectedTeacher,
        instrument: selectedInstrument,
        date: selectedScheduleDate,
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
