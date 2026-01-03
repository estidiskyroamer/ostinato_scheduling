import 'package:flutter/material.dart';
import 'package:ostinato/common/components/components.dart';
import 'package:ostinato/common/config.dart';

Widget summaryItem(
    BuildContext context, String value, String title, String info) {
  return GestureDetector(
    onTap: () {
      toastNotification(info);
    },
    child: SizedBox(
      width: MediaQuery.of(context).size.width / 3.5,
      child: Column(
        children: [
          Text(value,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium),
          Padding(padding: padding4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium),
            ],
          ),
          Padding(padding: padding8),
        ],
      ),
    ),
  );
}
