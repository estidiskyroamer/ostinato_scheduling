import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                  return SizedBox();
                  //return bottomSheet(context, scheduleId);
                });
          },
        ),
      ],
    ),
  );
}
