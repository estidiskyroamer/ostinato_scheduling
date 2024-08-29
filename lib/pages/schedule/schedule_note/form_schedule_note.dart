import 'package:flutter/material.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/schedule_note.dart';
import 'package:ostinato/services/schedule_service.dart';

class FormScheduleNotePage extends StatefulWidget {
  final ScheduleNote? scheduleNote;
  final String scheduleId;
  const FormScheduleNotePage(
      {super.key, required this.scheduleId, this.scheduleNote});

  @override
  State<FormScheduleNotePage> createState() => _FormScheduleNotePageState();
}

class _FormScheduleNotePageState extends State<FormScheduleNotePage> {
  TextEditingController noteController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  String pageTitle = "New Note";
  bool isLoading = false;
  bool isEdit = false;

  @override
  void initState() {
    setEdit();
    super.initState();
  }

  void setEdit() {
    if (mounted) {
      if (widget.scheduleNote != null) {
        setState(() {
          isEdit = true;
          pageTitle = "Edit Note";
          noteController.text = widget.scheduleNote!.note;
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
                  image: const AssetImage('assets/images/notes.jpeg')),
              Padding(padding: padding16),
              InputField(
                  textEditingController: noteController,
                  maxLines: 7,
                  hintText: "Write notes on this lesson..."),
              Padding(padding: padding16),
              isEdit
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
      scheduleId: widget.scheduleId,
    );
    ScheduleService().createNote(create).then((result) {
      setState(() {
        isLoading = false;
      });
      if (result) {
        Navigator.pop(context, true);
      }
    });
  }

  void updateNote(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    ScheduleNote update = ScheduleNote(
      id: widget.scheduleNote!.id!,
      note: noteController.text,
      scheduleId: widget.scheduleId,
    );
    ScheduleService().updateNote(update).then((result) {
      setState(() {
        isLoading = false;
      });
      if (result) {
        Navigator.pop(context, true);
      }
    });
  }
}
