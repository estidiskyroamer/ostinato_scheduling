import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/components/buttons.dart';
import 'package:ostinato/common/components/components.dart';
import 'package:ostinato/common/components/input_field.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/role.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/services/student_service.dart';
import 'package:ostinato/services/user_service.dart';

class FormStudentPage extends StatefulWidget {
  final User? student;
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

  late User selectedTeacher;

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
          User student = widget.student!;
          inspect(student);
          studentNameController.text = student.name;
          studentAddressController.text = student.address ?? '';
          studentPhoneController.text = student.phoneNumber;
          studentEmailController.text = student.email;
          studentBirthDate = student.birthDate ?? studentBirthDate;
          dateController.text =
              DateFormat("dd MMMM yyyy").format(studentBirthDate);
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
      selectedTeacher = User.fromJson(jsonDecode(teacher));
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
        address: studentAddressController.text,
        birthDate: studentBirthDate,
        password: studentPhoneController.text,
        isActive: 1,
        roles: [Role(id: '', name: 'student')],
        companies: selectedTeacher.companies);

    StudentService().createStudent(user).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value != null && context.mounted) {
        Navigator.pop(context);
      }
    });
  }

  void updateStudent(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    User user = User(
        id: widget.student!.id,
        name: studentNameController.text,
        email: studentEmailController.text,
        phoneNumber: studentPhoneController.text,
        address: studentAddressController.text,
        birthDate: studentBirthDate,
        password: widget.student!.password,
        isActive: 1,
        roles: widget.student!.roles,
        companies: widget.student!.companies);
    /* Student student = Student(
        id: widget.student!.id,
        user: user,
        address: studentAddressController.text,
        birthDate: studentBirthDate,
        isActive: 1,
        companyId: widget.student!.companyId); */
    UserService().updateUser(user).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value != null && context.mounted) {
        Navigator.pop(context);
      }
    });
  }
}
