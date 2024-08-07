import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/pages/schedule/common.dart';
import 'package:ostinato/pages/schedule/form_schedule.dart';
import 'package:ostinato/pages/schedule/schedule_note/schedule_note.dart';

Widget dashboardTitle(BuildContext context, String title) {
  return Container(
    padding: padding16,
    margin: const EdgeInsets.only(top: 8),
    decoration: const BoxDecoration(color: Colors.black12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    ),
  );
}

Widget dashboardStudentTime(BuildContext context, String scheduleId,
    DateTime time, String studentName, String instrument) {
  return Container(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
    margin: const EdgeInsets.only(bottom: 8, left: 32),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.black38)),
    ),
    child: Row(
      children: [
        Expanded(
            flex: 2,
            child: Container(
              child: Text(
                DateFormat("HH:mm").format(time),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )),
        Expanded(flex: 6, child: Text("$studentName ($instrument)")),
        Expanded(
          flex: 1,
          child: IconButton(
            icon: const Icon(
              FontAwesomeIcons.ellipsisVertical,
              color: Colors.black54,
            ),
            onPressed: () {
              showModalBottomSheet<void>(
                  context: context,
                  builder: (context) {
                    return bottomSheet(context, scheduleId);
                  });
            },
          ),
        ),
      ],
    ),
  );
}
