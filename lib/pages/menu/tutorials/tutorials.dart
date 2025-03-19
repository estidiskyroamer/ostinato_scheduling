import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ostinato/common/config.dart';

class TutorialsPage extends StatelessWidget {
  const TutorialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tutorials",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Container(
        padding: padding16,
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 12, bottom: 6),
                  child: Text(
                    "Students",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                studentTutorial(context),
                Container(
                  padding: const EdgeInsets.only(top: 12, bottom: 6),
                  child: Text(
                    "Schedules",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                scheduleTutorial(context),
                Container(
                  padding: const EdgeInsets.only(top: 12, bottom: 6),
                  child: Text(
                    "Teacher",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                teacherTutorial(context)
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget studentTutorial(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.users,
              size: 16,
            ),
            title: Text(
              "View your students",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.userPlus,
              size: 16,
            ),
            title: Text(
              "Add new student",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.userPen,
              size: 16,
            ),
            title: Text(
              "Edit student data",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.userCheck,
              size: 16,
            ),
            title: Text(
              "Activate or deactivate student",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget scheduleTutorial(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.calendarWeek,
              size: 16,
            ),
            title: Text(
              "View monthly schedule",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.calendarPlus,
              size: 16,
            ),
            title: Text(
              "Add new schedule",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.share,
              size: 16,
            ),
            title: Text(
              "Share a schedule",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.rotate,
              size: 16,
            ),
            title: Text(
              "Reschedule a lesson",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.calendarDay,
              size: 16,
            ),
            title: Text(
              "Update a schedule's status",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.noteSticky,
              size: 16,
            ),
            title: Text(
              "Add a note to a schedule",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget teacherTutorial(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.calendarCheck,
              size: 16,
            ),
            title: Text(
              "Check your current schedule",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.gaugeHigh,
              size: 16,
            ),
            title: Text(
              "Check your performance",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
