import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/components/components.dart';
import 'package:ostinato/common/components/theme_extension.dart';
import 'package:ostinato/common/config.dart';

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
          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).extension<OstinatoThemeExtension>()!.headerForegroundColor),
        )
      ],
    ),
  );
}
