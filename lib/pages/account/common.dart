import 'package:flutter/material.dart';
import 'package:ostinato/common/config.dart';

Widget summaryItem(BuildContext context, String value, String title) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 3.5,
    child: Column(
      children: [
        Text(value,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium),
        Padding(padding: padding4),
        Text(title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .merge(const TextStyle(color: Colors.black))),
        Padding(padding: padding8),
      ],
    ),
  );
}
