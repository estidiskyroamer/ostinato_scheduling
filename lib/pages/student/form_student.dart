import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/services/student_service.dart';
import 'package:ostinato/services/user_service.dart';

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
  DateTime selectedScheduleDate = DateTime.now();
  DateTime selectedScheduleStartTime = DateTime.now();
  DateTime selectedScheduleEndTime = DateTime.now();
  String pageTitle = "New Student";

  Future<StudentDetail?>? _studentDetail;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setEdit();
  }

  void setEdit() {
    if (mounted) {
      if (widget.studentId != null) {
        setState(() {
          pageTitle = "Edit Student";
          _studentDetail = StudentService().getStudentDetail(widget.studentId!);
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
              FutureBuilder(
                future: _studentDetail,
                builder: (BuildContext context,
                    AsyncSnapshot<StudentDetail?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                        child: Config().loadingIndicator,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.hasData) {
                    Student student = snapshot.data!.data;
                    studentNameController.text = student.name;
                    studentAddressController.text = student.address;
                    studentPhoneController.text = student.phoneNumber;
                    studentEmailController.text = student.email;
                    studentBirthDate = student.birthDate;
                    dateController.text =
                        DateFormat("dd MMMM yyyy").format(student.birthDate);
                  }

                  return buildForm(context);
                },
              ),
            ],
          ),
        ),
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
                return inputDateTimePicker(
                    title: "Set Birth Date",
                    context: context,
                    selectedTime: studentBirthDate,
                    setTime: setBirthDate);
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
            : widget.studentId != null
                ? SolidButton(
                    action: () {
                      //Navigator.pop(context);
                    },
                    text: "Update")
                : SolidButton(
                    action: () {
                      setState(() {
                        isLoading = true;
                      });
                      User user = User(
                        name: studentNameController.text,
                        email: studentEmailController.text,
                        phoneNumber: studentPhoneController.text,
                        password: 'password',
                      );
                      UserService().createUser(user).then(
                        (result) {
                          if (result != null) {
                            Student student = Student(
                              userId: result.id,
                              name: result.name,
                              email: result.email,
                              phoneNumber: result.phoneNumber,
                              address: studentAddressController.text,
                              birthDate: studentBirthDate,
                              isActive: 1,
                            );
                            StudentService()
                                .createStudent(student)
                                .then((value) {
                              setState(() {
                                isLoading = false;
                              });
                              if (value) {
                                Navigator.pop(context);
                              }
                            });
                          }
                        },
                      );
                    },
                    text: "Add Student")
      ],
    );
  }
}
