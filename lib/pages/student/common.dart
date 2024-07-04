import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ostinato/common/component.dart';
import 'package:ostinato/common/config.dart';

Widget studentItem(BuildContext context, String name) {
  return Container(
    decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black38))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name),
        IconButton(
          icon: const Icon(
            FontAwesomeIcons.ellipsisVertical,
            color: Colors.black54,
          ),
          onPressed: () {
            showModalBottomSheet<void>(
                context: context,
                builder: (context) {
                  return bottomSheet(context, '1');
                });
          },
        ),
      ],
    ),
  );
}

Widget bottomSheet(BuildContext context, String studentId) {
  return ItemBottomSheet(
    child: Column(
      children: [
        Text(
          "Status",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontStyle: FontStyle.italic),
        ),
        Row(
          children: [
            RowIconButton(
                onTap: () {
                  print("payment $studentId");
                },
                icon: FontAwesomeIcons.moneyBillTransfer,
                label: "Payment"),
            RowIconButton(
                onTap: () {
                  print("schedule $studentId");
                },
                icon: FontAwesomeIcons.clipboardCheck,
                label: "Attendance"),
          ],
        ),
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
                  print("done $studentId");
                },
                icon: FontAwesomeIcons.magnifyingGlass,
                label: "Detail"),
            RowIconButton(
                onTap: () {
                  print("reschedule $studentId");
                },
                icon: FontAwesomeIcons.pencil,
                label: "Edit"),
            RowIconButton(
                onTap: () {
                  print("cancel $studentId");
                },
                icon: FontAwesomeIcons.trash,
                label: "Delete"),
          ],
        ),
      ],
    ),
  );
}
