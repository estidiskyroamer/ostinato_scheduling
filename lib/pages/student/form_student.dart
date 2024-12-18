import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/components/buttons.dart';
import 'package:ostinato/common/components/component.dart';
import 'package:ostinato/common/components/input_field.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/models/teacher.dart';
import 'package:ostinato/services/student_service.dart';

class FormStudentPage extends StatefulWidget {
  final Student? student;
  const FormStudentPage({super.key, this.student});

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
  DateTime selectedScheduleDate = DateTime.now();
  DateTime selectedScheduleStartTime = DateTime.now();
  DateTime selectedScheduleEndTime = DateTime.now();
  String pageTitle = "New Student";

  late Teacher selectedTeacher;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setEdit();
    getTeacher();
  }

  void setEdit() {
    if (mounted) {
      if (widget.student != null) {
        setState(() {
          pageTitle = "Edit Student";
          Student student = widget.student!;
          studentNameController.text = student.user.name;
          studentAddressController.text = student.address;
          studentPhoneController.text = student.user.phoneNumber;
          studentEmailController.text = student.user.email;
          studentBirthDate = student.birthDate;
          dateController.text =
              DateFormat("dd MMMM yyyy").format(student.birthDate);
        });
      }
    }
  }

  void setBirthDate(DateTime selectedDate) {
    if (mounted) {
      setState(() {
        studentBirthDate = selectedDate;
        dateController.text =
            DateFormat('dd MMMM yyyy').format(studentBirthDate);
      });
    }
  }

  int setRandomImage() {
    final random = Random();
    int index = random.nextInt(6);
    return index;
  }

  void getTeacher() async {
    String? teacher = await Config().storage.read(key: 'teacher');
    if (teacher != null) {
      selectedTeacher = Teacher.fromJson(jsonDecode(teacher));
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
      body: SingleChildScrollView(
        child: Container(padding: padding16, child: buildForm(context)),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return Column(
      children: [
        InputField(
            textEditingController: studentNameController,
            hintText: "Student name"),
        InputField(
          textEditingController: dateController,
          hintText: "Birth date",
          onTap: () async {
            showModalBottomSheet<void>(
              context: context,
              builder: (context) {
                return ItemBottomSheet(
                    child: inputDateTimePicker(
                        title: "Set Birth Date",
                        context: context,
                        selectedTime: studentBirthDate,
                        setTime: setBirthDate));
              },
            );
          },
          isReadOnly: true,
        ),
        InputField(
            textEditingController: studentAddressController,
            hintText: "Home address"),
        InputField(
            textEditingController: studentEmailController, hintText: "E-mail"),
        InputField(
          textEditingController: studentPhoneController,
          hintText: "Phone number",
          inputType: TextInputType.phone,
        ),
        Padding(padding: padding16),
        isLoading
            ? Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 6,
                  child: Config().loadingIndicator,
                ),
              )
            : widget.student != null
                ? SolidButton(
                    action: () {
                      if (studentNameController.text != "" &&
                          studentAddressController.text != "" &&
                          studentPhoneController.text != "" &&
                          studentEmailController.text != "" &&
                          dateController.text != "") {
                        updateStudent(context);
                      }
                    },
                    text: "Update")
                : SolidButton(
                    action: () {
                      if (studentNameController.text != "" &&
                          studentAddressController.text != "" &&
                          studentPhoneController.text != "" &&
                          studentEmailController.text != "" &&
                          dateController.text != "") {
                        createStudent(context);
                      }
                    },
                    text: "Add Student")
      ],
    );
  }

  void createStudent(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    User user = User(
      name: studentNameController.text,
      email: studentEmailController.text,
      phoneNumber: studentPhoneController.text,
      password: studentPhoneController.text,
    );
    Student student = Student(
        user: user,
        address: studentAddressController.text,
        birthDate: studentBirthDate,
        isActive: 1,
        companyId: selectedTeacher.companyId!);
    StudentService().createStudent(student).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value) {
        Navigator.pop(context);
      }
    });
  }

  void updateStudent(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    User user = User(
      id: widget.student!.user.id,
      name: studentNameController.text,
      email: studentEmailController.text,
      phoneNumber: studentPhoneController.text,
      password: 'password',
    );
    Student student = Student(
        id: widget.student!.id,
        user: user,
        address: studentAddressController.text,
        birthDate: studentBirthDate,
        isActive: 1,
        companyId: widget.student!.companyId);
    StudentService().updateStudent(student).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value) {
        Navigator.pop(context);
      }
    });
  }
}
