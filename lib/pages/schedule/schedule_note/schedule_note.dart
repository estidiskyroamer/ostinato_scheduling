import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/schedule/common.dart';
import 'package:ostinato/pages/schedule/schedule_note/form_schedule_note.dart';

class ScheduleNotePage extends StatefulWidget {
  final String? scheduleId;
  const ScheduleNotePage({super.key, this.scheduleId});

  @override
  State<ScheduleNotePage> createState() => _ScheduleNotePageState();
}

class _ScheduleNotePageState extends State<ScheduleNotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notes",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FormScheduleNotePage()));
              },
              icon: const Icon(FontAwesomeIcons.plus))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            noteItem(
                context,
                "1",
                "Great job on the dynamics in the first movement of your piano piece. For the next lesson, focus on the tempo changes in the second movement to ensure a smooth transition.",
                DateTime(2024, 7, 8, 18, 0)),
            noteItem(
                context,
                "1",
                "Your rendition of \"Fur Elise\" is improving! Pay attention to the finger positioning in measures 12-16 to avoid any missed notes. Practice slowly to build muscle memory.",
                DateTime(2024, 7, 8, 18, 10)),
            noteItem(
                context,
                "1",
                "Please practice \"Canon in D\" for the next lesson. Focus on the left-hand accompaniment to ensure it stays even and supports the melody effectively.",
                DateTime(2024, 7, 8, 18, 15)),
            noteItem(
                context,
                "1",
                "Your performance of \"Moonlight Sonata\" was very expressive. To enhance it further, work on sustaining the pedal correctly to avoid muddying the sound in the middle section.",
                DateTime(2024, 7, 8, 18, 17)),
          ],
        ),
      ),
    );
  }
}
