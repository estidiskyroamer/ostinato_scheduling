import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ostinato/common/components/theme_extension.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/pages/student/common/student_bottom_sheet.dart';
import 'package:ostinato/pages/student/form_student.dart';
import 'package:ostinato/services/student_service.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> with AutomaticKeepAliveClientMixin {
  TextEditingController searchController = TextEditingController();
  late Future<StudentList?> _activeStudentList;
  late Future<StudentList?> _inactiveStudentList;
  int totalStudents = 0;

  @override
  void initState() {
    super.initState();
    getStudents();
  }

  @override
  bool get wantKeepAlive => true;

  void getStudents() {
    setState(() {
      _activeStudentList = StudentService().getStudents(1);
      _inactiveStudentList = StudentService().getStudents(0);
    });
  }

  void addStudent(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FormStudentPage())).then((value) => getStudents());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Student List",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          bottom: const TabBar(tabs: [
            Tab(
              text: "Active",
            ),
            Tab(
              text: "Inactive",
            )
          ]),
          actions: [
            IconButton(
                onPressed: () {
                  addStudent(context);
                },
                icon: const Icon(LucideIcons.plus))
          ],
          automaticallyImplyLeading: false,
        ),
        body: TabBarView(
          children: [studentListView(_activeStudentList), studentListView(_inactiveStudentList)],
        ),
      ),
    );
  }

  Widget studentListView(Future<StudentList?> studentList) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      width: double.infinity,
      child: FutureBuilder(
        future: studentList,
        builder: (BuildContext context, AsyncSnapshot<StudentList?> snapshot) {
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
          if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return const Center(child: Text('No students yet'));
          }
          final students = snapshot.data!.data;

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    getStudents();
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: students.length,
                    itemBuilder: (BuildContext context, int index) {
                      User student = students[index];
                      return studentItem(context, student);
                    },
                  ),
                ),
              ),
              Container(
                padding: padding8,
                child: Text("Total: ${students.length}"),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget studentItem(BuildContext context, User student) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).extension<OstinatoThemeExtension>()!.separatorColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(student.name),
          IconButton(
            icon: const Icon(
              LucideIcons.ellipsisVertical,
              size: 16,
            ),
            visualDensity: VisualDensity.comfortable,
            onPressed: () {
              showModalBottomSheet<void>(
                  context: context,
                  builder: (context) {
                    return StudentBottomSheet(student: student, onChanged: getStudents);
                  });
            },
          ),
        ],
      ),
    );
  }
}
