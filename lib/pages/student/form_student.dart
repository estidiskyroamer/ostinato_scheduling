import 'dart:developer';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';

class FormStudentPage extends StatefulWidget {
  final String? studentId;
  const FormStudentPage({super.key, this.studentId});

  @override
  State<FormStudentPage> createState() => _FormStudentPageState();
}

class _FormStudentPageState extends State<FormStudentPage> {
  TextEditingController studentNameController = TextEditingController();
  TextEditingController studentAddressController = TextEditingController();
  TextEditingController studentPhoneController = TextEditingController();
  TextEditingController studentEmailController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  DateTime studentBirthDate =
      DateTime.now().subtract(const Duration(days: 365 * 10));
  DateTime selectedScheduleStartDate = DateTime.now();
  DateTime selectedScheduleStartTime = DateTime.now();
  DateTime selectedScheduleEndTime = DateTime.now();
  String pageTitle = "New Student";

  @override
  void initState() {
    setEdit();
    super.initState();
  }

  void setEdit() {
    if (mounted) {
      if (widget.studentId != null) {
        setState(() {
          pageTitle = "Edit Student";
        });
      }
    }
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
                  image: const AssetImage('assets/images/student.jpeg')),
              Padding(padding: padding16),
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
                  textEditingController: studentAddressController,
                  hintText: "Home address"),
              InputField(
                  textEditingController: studentEmailController,
                  hintText: "E-mail"),
              InputField(
                textEditingController: studentPhoneController,
                hintText: "Phone number",
                inputType: TextInputType.phone,
              ),
              Padding(padding: padding16),
              widget.studentId != null
                  ? SolidButton(
                      action: () {
                        Navigator.pop(context);
                      },
                      text: "Update")
                  : SolidButton(
                      action: () {
                        Navigator.pop(context);
                      },
                      text: "Add Student")
            ],
          ),
        ),
      ),
    );
  }
}
