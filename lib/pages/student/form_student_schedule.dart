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

class FormStudentSchedulePage extends StatefulWidget {
  final String? scheduleId;
  final String? studentId;
  const FormStudentSchedulePage({super.key, this.scheduleId, this.studentId});

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

  late String? _teacherId;
  late String? _teacherName;
  late StudentList? _studentList;
  late Student selectedStudent;
  late InstrumentList? _instrumentList;
  late Instrument selectedInstrument;

  DateTime currentTime = DateTime.now();
  bool isLoading = false;
  bool isStudentLoading = false;

  @override
  void initState() {
    setEdit();
    getTeacher();
    getStudent();
    getInstrumentList();
    super.initState();
  }

  void getTeacher() async {
    _teacherId = await Config().storage.read(key: 'teacher_id');
    _teacherName = await Config().storage.read(key: 'teacher_name');
    teacherNameController.text = _teacherName!;
  }

  void getStudent() async {
    if (widget.studentId != null) {
      StudentDetail? studentDetail =
          await StudentService().getStudentDetail(widget.studentId!);
      if (studentDetail != null) {
        selectedStudent = studentDetail.data;
        studentNameController.text = selectedStudent.name;
      }
    }
  }

  void getStudentList() async {
    setState(() {
      isStudentLoading = true;
    });
    _studentList = await StudentService().getStudents();
    setState(() {
      isStudentLoading = false;
    });
  }

  void getInstrumentList() async {
    _instrumentList = await InstrumentService().getInstruments();
  }

  void setEdit() {
    if (mounted) {
      if (widget.scheduleId != null) {
        setState(() {
          pageTitle = "Edit Schedule";
        });
      }
    }
  }

  void setStudent(Student student) {
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
            const Duration(minutes: 30),
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
              hintText: "Teacher name"),
          isStudentLoading
              ? Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 6,
                    child: Config().loadingIndicator,
                  ),
                )
              : InputField(
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
                      title: "Set instrument",
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
                const Text("weeks")
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
              : widget.scheduleId != null
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
                            studentId: selectedStudent.id!,
                            teacherId: _teacherId!,
                            instrumentId: selectedInstrument.id,
                            date: selectedScheduleDate,
                            startTime: DateFormat('H:mm')
                                .format(selectedScheduleStartTime),
                            endTime: DateFormat('H:mm')
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
