import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/schedule_note.dart';
import 'package:ostinato/pages/schedule/common.dart';
import 'package:ostinato/pages/schedule/schedule_note/form_schedule_note.dart';
import 'package:ostinato/services/schedule_service.dart';

class ScheduleNotePage extends StatefulWidget {
  final Schedule schedule;
  const ScheduleNotePage({super.key, required this.schedule});

  @override
  State<ScheduleNotePage> createState() => _ScheduleNotePageState();
}

class _ScheduleNotePageState extends State<ScheduleNotePage> {
  late Future<ScheduleNoteList?> _scheduleNoteList;

  @override
  void initState() {
    getScheduleNotes();
    super.initState();
  }

  void getScheduleNotes() {
    if (mounted) {
      setState(() {
        _scheduleNoteList = ScheduleService().getAllNotes(widget.schedule);
      });
    }
  }

  void editNote(ScheduleNote scheduleNote) {
    Navigator.pop(context);
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => FormScheduleNotePage(
                  scheduleNote: scheduleNote,
                  scheduleId: scheduleNote.scheduleId,
                )))
        .then((value) => getScheduleNotes());
  }

  void deleteNote(ScheduleNote scheduleNote) async {
    ScheduleService().deleteNote(scheduleNote).then((value) {
      if (value) {
        getScheduleNotes();
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Notes",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => FormScheduleNotePage(
                                scheduleId: widget.schedule.id!,
                              )))
                      .then((value) => getScheduleNotes());
                },
                icon: const Icon(FontAwesomeIcons.plus))
          ],
        ),
        body: SizedBox(
          height: double.infinity,
          child: FutureBuilder(
              future: _scheduleNoteList,
              builder: (BuildContext context,
                  AsyncSnapshot<ScheduleNoteList?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 6,
                      child: Config().loadingIndicator,
                    ),
                  );
                }
                inspect(snapshot);
                if (!snapshot.hasData) {
                  return const Center(child: Text('No notes yet'));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                ScheduleNoteList noteList = snapshot.data!;
                List<ScheduleNote> notes = noteList.scheduleNote;
                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (BuildContext context, int index) {
                    ScheduleNote note = notes[index];
                    return noteItem(context, note);
                  },
                );
              }),
        ));
  }

  Widget noteItem(BuildContext context, ScheduleNote note) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      margin: const EdgeInsets.only(top: 8, left: 32),
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(color: Colors.black38),
      )),
      child: Row(
        children: [
          Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(note.note),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Text(
                      DateFormat("dd MMMM yyyy HH:mm").format(note.createdAt!),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              )),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(
                FontAwesomeIcons.ellipsisVertical,
                color: Colors.black,
              ),
              onPressed: () {
                showModalBottomSheet<void>(
                    context: context,
                    builder: (context) {
                      return noteBottomSheet(context, note, () {
                        editNote(note);
                      }, () {
                        deleteNote(note);
                      });
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
