import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/components/buttons.dart';
import 'package:ostinato/common/components/components.dart';
import 'package:ostinato/common/components/theme_extension.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule_note.dart';

Widget noteBottomSheet(BuildContext context, ScheduleNote scheduleNote,
    Function editScheduleNote, Function deleteScheduleNote) {
  return ItemBottomSheet(
    child: Column(
      children: [
        Text(
          "Manage",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontStyle: FontStyle.italic),
        ),
        Row(
          children: [
            RowIconButton(
                onTap: () {
                  editScheduleNote();
                },
                icon: FontAwesomeIcons.pencil,
                label: "Edit"),
            RowIconButton(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ActionDialog(
                        action: () {
                          deleteScheduleNote();
                        },
                        contentText:
                            "Are you sure you want to delete this data?",
                        actionText: "Delete",
                      );
                    },
                  );
                },
                icon: FontAwesomeIcons.trash,
                label: "Delete"),
          ],
        )
      ],
    ),
  );
}

Widget scheduleDate(BuildContext context, DateTime date) {
  return listHeader(
    context: context,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          DateFormat("dd MMM").format(date),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Padding(padding: padding4),
        Text(
          DateFormat("EEEE").format(date),
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color:  Theme.of(context).extension<OstinatoThemeExtension>()!.headerForegroundColor),
        )
      ],
    ),
  );
}
