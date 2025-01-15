import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/components/components.dart';

Widget detailTitle(BuildContext context, String title, [Widget? action]) {
  return Container(
    padding: const EdgeInsets.only(left: 16, right: 16),
    margin: const EdgeInsets.only(top: 16),
    decoration: const BoxDecoration(color: Colors.black12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        action ?? const SizedBox()
      ],
    ),
  );
}

Widget detailItem(BuildContext context, String title, String content) {
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontStyle: FontStyle.italic),
        ),
      ),
      Expanded(
        flex: 2,
        child: Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    ],
  );
}

Widget detailScheduleDate(BuildContext context, DateTime date) {
  return listHeader(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat("dd MMMM yyyy").format(date),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(
          DateFormat("EEEE").format(date),
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: Colors.black45),
        )
      ],
    ),
  );
}
