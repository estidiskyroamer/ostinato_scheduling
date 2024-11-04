import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/pages/schedule/schedule_note/schedule_note.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:toastification/toastification.dart';

class InputField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final double marginTop;
  final double marginBottom;
  final Color borderColor;
  final TextInputType inputType;
  final TextCapitalization capitalization;
  final VoidCallback? onTap;
  final bool isReadOnly;
  final bool isPassword;
  final int maxLines;

  const InputField(
      {super.key,
      required this.textEditingController,
      required this.hintText,
      this.marginTop = 6.0,
      this.marginBottom = 6.0,
      this.borderColor = Colors.black,
      this.inputType = TextInputType.text,
      this.capitalization = TextCapitalization.words,
      this.onTap,
      this.isReadOnly = false,
      this.isPassword = false,
      this.maxLines = 1});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 6),
      margin:
          EdgeInsets.only(top: widget.marginTop, bottom: widget.marginBottom),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: widget.borderColor, width: 1.0),
          bottom: BorderSide(color: widget.borderColor, width: 1.0),
          left: BorderSide(color: widget.borderColor, width: 6.0),
        ),
      ),
      child: TextField(
        onTap: widget.onTap,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontStyle: FontStyle.italic, color: Colors.black38),
          isDense: true,
          border: InputBorder.none,
        ),
        controller: widget.textEditingController,
        keyboardType: widget.inputType,
        obscureText: widget.isPassword,
        style: Theme.of(context).textTheme.bodyMedium,
        readOnly: widget.isReadOnly,
        maxLines: widget.maxLines,
      ),
    );
  }
}

class ItemBottomSheet extends StatelessWidget {
  final Widget child;

  const ItemBottomSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Container(
          padding: padding16,
          color: Theme.of(context).bottomSheetTheme.backgroundColor,
          child: child)
    ]);
  }
}

class RowIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;

  const RowIconButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: padding16,
          margin: padding8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: HexColor("#FFF0D4"),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: Colors.black,
              ),
              Padding(
                padding: padding4,
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SolidButton extends StatelessWidget {
  final VoidCallback action;
  final String text;

  const SolidButton({super.key, required this.action, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: Colors.black,
          shape: const LinearBorder(),
          padding: padding8),
      onPressed: action,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width / 3,
            maxWidth: MediaQuery.of(context).size.width),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final VoidCallback action;
  final String text;

  const OutlineButton({super.key, required this.action, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(
              side: BorderSide(width: 1.0, color: Colors.black)),
          padding: padding8),
      onPressed: action,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width / 3,
            maxWidth: MediaQuery.of(context).size.width),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .merge(const TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
}

class StyledTextButton extends StatelessWidget {
  final VoidCallback action;
  final String text;

  const StyledTextButton({super.key, required this.action, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: action,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width / 4,
            maxWidth: MediaQuery.of(context).size.width),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .merge(const TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
}

class ActionDialog extends StatelessWidget {
  final VoidCallback action;
  final String contentText;
  final String actionText;

  const ActionDialog(
      {super.key,
      required this.action,
      required this.contentText,
      required this.actionText});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 0,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      insetPadding: EdgeInsets.zero,
      child: Container(
        padding: padding16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              contentText,
              textAlign: TextAlign.center,
            ),
            Padding(padding: padding16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StyledTextButton(
                    action: () {
                      Navigator.pop(context);
                    },
                    text: "Cancel"),
                SolidButton(action: action, text: actionText),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget listBottomSheet<T>(
    {required BuildContext context,
    required List<T> items,
    required String title,
    required Function(T) onItemSelected,
    required Widget Function(T) itemContentBuilder}) {
  return ItemBottomSheet(
    child: Column(
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontStyle: FontStyle.italic),
        ),
        Padding(padding: padding16),
        SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                T item = items[index];
                return GestureDetector(
                  onTap: () {
                    onItemSelected(item);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.black38))),
                    child: itemContentBuilder(item),
                  ),
                );
              }),
        )
      ],
    ),
  );
}

Widget inputDateTimePicker({
  required BuildContext context,
  required String title,
  String pickerType = 'date',
  required DateTime selectedTime,
  required Function setTime,
}) {
  assert(pickerType == 'date' || pickerType == 'time');
  DateFormat dateFormat;
  switch (pickerType) {
    case 'date':
      dateFormat = DateFormat('yyyy MM dd EEEE');
      break;
    case 'time':
      dateFormat = DateFormat('HH:mm');
      break;
    default:
      dateFormat = DateFormat('yyyy MM dd');
      break;
  }
  DateTime currentTime = DateTime.now();
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontStyle: FontStyle.italic),
      ),
      ScrollDateTimePicker(
        itemExtent: 48,
        visibleItem: 5,
        infiniteScroll: false,
        centerWidget: DateTimePickerCenterWidget(
          builder: (context, constraints, child) {
            return Container(
              margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              padding: padding8,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black, width: 1.0),
                  bottom: BorderSide(color: Colors.black, width: 1.0),
                  left: BorderSide(color: Colors.black, width: 6.0),
                ),
              ),
            );
          },
        ),
        dateOption: DateTimePickerOption(
          dateFormat: dateFormat,
          minDate: DateTime(currentTime.year - 100, 1),
          maxDate: DateTime(currentTime.year + 5, 12),
          initialDate: selectedTime,
        ),
        style: DateTimePickerStyle(
            activeStyle: const TextStyle(fontWeight: FontWeight.bold)),
        onChange: (time) {
          setTime(time);
        },
      ),
      Padding(padding: padding8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StyledTextButton(
              action: () {
                Navigator.pop(context);
              },
              text: "Cancel"),
          SolidButton(
              action: () {
                Navigator.pop(context);
              },
              text: "Apply"),
        ],
      ),
      Padding(padding: padding8),
    ],
  );
}

Widget listHeader({required Widget child}) {
  return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(color: Colors.black12),
      child: child);
}

Container scheduleItem(bool isCurrentSchedule, Schedule schedule,
    BuildContext context, Widget button) {
  DateTime startTime = DateFormat.Hm().parse(schedule.startTime);
  DateTime endTime = DateFormat.Hm().parse(schedule.endTime);
  Duration diff = endTime.difference(startTime);
  return Container(
    padding: isCurrentSchedule
        ? const EdgeInsets.fromLTRB(32, 8, 16, 8)
        : const EdgeInsets.fromLTRB(0, 8, 16, 8),
    margin:
        isCurrentSchedule ? EdgeInsets.zero : const EdgeInsets.only(left: 32),
    decoration: BoxDecoration(
        color: isCurrentSchedule ? HexColor("#FFF0D4") : Colors.transparent,
        border: const Border(
          bottom: BorderSide(color: Colors.black38),
        )),
    child: Row(
      children: [
        Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.startTime,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: schedule.status == 'canceled'
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
                Text(
                  '${diff.inMinutes} minutes',
                  style: Theme.of(context).textTheme.labelSmall,
                )
              ],
            )),
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                schedule.student.user.name,
              ),
              Text(
                schedule.instrument.name,
                style: Theme.of(context).textTheme.labelSmall,
              )
            ],
          ), /* Row(
            children: [
              Text(
                "${schedule.student.user.name} (${schedule.instrument.name})",
                style: TextStyle(
                    decoration: schedule.status == 'canceled'
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              scheduleStatus(schedule.status)
            ],
          ), */
        ),
        button
      ],
    ),
  );
}

Widget scheduleStatus(String? status) {
  switch (status) {
    case "done":
      return Container(
        padding: const EdgeInsets.only(left: 8),
        child: Icon(
          FontAwesomeIcons.circleCheck,
          color: HexColor('#2ec27d'),
          size: 18,
        ),
      );
    case "rescheduled":
      return Container(
        padding: const EdgeInsets.only(left: 8),
        child: Icon(
          FontAwesomeIcons.rotate,
          color: HexColor('#ffba47'),
          size: 18,
        ),
      );
    case "canceled":
      return Container(
        padding: const EdgeInsets.only(left: 8),
        child: Icon(
          FontAwesomeIcons.circleXmark,
          color: HexColor('#c70e03'),
          size: 18,
        ),
      );
    default:
      return const SizedBox();
  }
}

Widget scheduleBottomSheet(
    BuildContext context,
    Schedule schedule,
    Function done,
    Function rescheduled,
    Function canceled,
    Function editSchedule,
    Function deleteSchedule) {
  return ItemBottomSheet(
    child: Column(
      children: [
        schedule.status == 'done' || schedule.status == 'canceled'
            ? const SizedBox()
            : Column(
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
                            Navigator.pop(context);
                            String date = DateFormat("dd MMMM yyyy")
                                .format(schedule.date);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ActionDialog(
                                  action: () {
                                    done();
                                  },
                                  contentText:
                                      "Are you sure you want to mark this schedule as done?"
                                      "\n$date\n${schedule.startTime} - ${schedule.student.user.name} (${schedule.instrument.name})",
                                  actionText: "Mark as Done",
                                );
                              },
                            );
                          },
                          icon: FontAwesomeIcons.circleCheck,
                          label: "Done"),
                      RowIconButton(
                          onTap: () {
                            Navigator.of(context).pop();
                            rescheduled();
                          },
                          icon: FontAwesomeIcons.rotate,
                          label: "Reschedule"),
                      RowIconButton(
                          onTap: () {
                            Navigator.pop(context);
                            String date = DateFormat("dd MMMM yyyy")
                                .format(schedule.date);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ActionDialog(
                                  action: () {
                                    canceled();
                                  },
                                  contentText:
                                      "Are you sure you want to mark this schedule as canceled?"
                                      "\n$date\n${schedule.startTime} - ${schedule.student.user.name} (${schedule.instrument.name})",
                                  actionText: "Mark as Canceled",
                                );
                              },
                            );
                          },
                          icon: FontAwesomeIcons.circleXmark,
                          label: "Canceled"),
                    ],
                  ),
                  Padding(padding: padding8),
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
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ScheduleNotePage(
                            schedule: schedule,
                          )));
                },
                icon: FontAwesomeIcons.file,
                label: "Notes"),
            schedule.status == 'canceled' || schedule.status == 'done'
                ? const SizedBox()
                : RowIconButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      editSchedule();
                    },
                    icon: FontAwesomeIcons.pencil,
                    label: "Edit"),
            RowIconButton(
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return ActionDialog(
                            action: () {
                              deleteSchedule();
                            },
                            contentText:
                                "Are you sure you want to delete this data?",
                            actionText: "Delete",
                          );
                        },
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

ToastificationItem toastNotification(String text) {
  return toastification.showCustom(
    alignment: Alignment.bottomCenter,
    autoCloseDuration: const Duration(seconds: 5),
    builder: (context, holder) {
      return Center(
        child: Container(
          padding: padding8,
          margin: padding16,
          color: Colors.black,
          child: Text(
            text,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      );
    },
  );
}

class NavBar extends StatefulWidget {
  final List<BottomNavBarItem> items;
  int currentIndex;
  final Color? backgroundColor;
  Function(int)? onTap;

  NavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    this.backgroundColor,
    required this.onTap,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 12,
      color: widget.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          widget.items.length,
          (index) => NavBarItem(
            onTap: () {
              setState(() {
                widget.currentIndex = index;
                widget.onTap!(widget.currentIndex);
              });
            },
            width: MediaQuery.of(context).size.width / 4,
            isSelected: widget.currentIndex == index,
            item: widget.items[index],
            backgroundColor: widget.backgroundColor,
          ),
        ),
      ),
    );
  }
}

class BottomNavBarItem {
  final String label;
  final IconData icon;
  final Widget page;
  BottomNavBarItem({
    required this.label,
    required this.icon,
    required this.page,
  });
}

class NavBarItem extends StatefulWidget {
  final Color? backgroundColor;
  final bool isSelected;
  final Function onTap;
  final BottomNavBarItem item;
  final double width;
  const NavBarItem(
      {super.key,
      this.backgroundColor,
      this.isSelected = false,
      required this.onTap,
      required this.width,
      required this.item});

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: widget.isSelected ? Colors.black : Colors.transparent,
        width: widget.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.item.icon,
              color: widget.isSelected ? widget.backgroundColor : Colors.black,
            ),
            Padding(padding: padding4),
            Text(widget.item.label,
                style: widget.isSelected
                    ? Theme.of(context).textTheme.displaySmall!.merge(TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.backgroundColor))
                    : Theme.of(context).textTheme.labelSmall)
          ],
        ),
      ),
    );
  }
}
