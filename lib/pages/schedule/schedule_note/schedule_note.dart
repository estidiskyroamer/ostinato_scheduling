import 'package:flutter/material.dart';
import 'package:ostinato/common/components/buttons.dart';
import 'package:ostinato/common/components/input_field.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/schedule_note.dart';
import 'package:ostinato/services/schedule_service.dart';

class ScheduleNotePage extends StatefulWidget {
  final Schedule schedule;
  const ScheduleNotePage({super.key, required this.schedule});

  @override
  State<ScheduleNotePage> createState() => _ScheduleNotePageState();
}

class _ScheduleNotePageState extends State<ScheduleNotePage> {
  late ScheduleNote _scheduleNote;
  TextEditingController noteController = TextEditingController();
  bool isLoading = false;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    getScheduleNotes();
  }

  void getScheduleNotes() async {
    isLoading = true;
    ScheduleNoteList? list =
        await ScheduleService().getAllNotes(widget.schedule);
    if (mounted) {
      if (list != null && list.scheduleNote.isNotEmpty) {
        setState(() {
          isEdit = true;
          isLoading = false;
          _scheduleNote = list.scheduleNote[0];
          noteController.text = _scheduleNote.note;
        });
      } else {
        setState(() {
          isEdit = false;
          isLoading = false;
        });
      }
    }
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
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: padding16,
          child: Column(
            children: [
              Image(
                  width: MediaQuery.sizeOf(context).width / 2,
                  image: const AssetImage('assets/images/notes.jpeg')),
              Padding(padding: padding16),
              InputField(
                  textEditingController: noteController,
                  maxLines: 7,
                  inputType: TextInputType.multiline,
                  capitalization: TextCapitalization.sentences,
                  hintText: "Write notes on this lesson..."),
              Padding(padding: padding16),
              isLoading
                  ? Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                        child: Config().loadingIndicator,
                      ),
                    )
                  : isEdit
                      ? SolidButton(
                          action: () {
                            updateNote(context);
                          },
                          text: "Update")
                      : SolidButton(
                          action: () {
                            createNote(context);
                          },
                          text: "Save"),
            ],
          ),
        ),
      ),
    );
  }

  void createNote(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    ScheduleNote create = ScheduleNote(
      note: noteController.text,
      scheduleId: widget.schedule.id!,
    );
    ScheduleService().createNote(create).then((result) {
      setState(() {
        isLoading = false;
      });
      if (result) {
        getScheduleNotes();
      }
    });
  }

  void updateNote(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    ScheduleNote update = ScheduleNote(
      id: _scheduleNote.id,
      note: noteController.text,
      scheduleId: widget.schedule.id!,
    );
    ScheduleService().updateNote(update).then((result) {
      setState(() {
        isLoading = false;
      });
      if (result) {
        getScheduleNotes();
      }
    });
  }
}
