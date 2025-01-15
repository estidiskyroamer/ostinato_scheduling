import 'package:flutter/material.dart';
import 'package:ostinato/common/components/buttons.dart';
import 'package:ostinato/common/components/components.dart';
import 'package:ostinato/common/components/input_field.dart';
import 'package:ostinato/common/config.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController courseLengthController = TextEditingController();
  TextEditingController scheduleRepeatController = TextEditingController();

  late String courseLength;
  late String repeat;

  void getSettings() async {
    String? courseLengthString =
        await Config().storage.read(key: 'course_length');
    String? repeatString = await Config().storage.read(key: 'repeat');
    setState(() {
      courseLengthController.text =
          courseLengthString ?? Config().courseLengthDef.toString();
      scheduleRepeatController.text =
          repeatString ?? Config().repeatDef.toString();
    });
  }

  void saveSettings() async {
    await Config()
        .storage
        .write(key: 'course_length', value: courseLengthController.text);
    await Config()
        .storage
        .write(key: 'repeat', value: scheduleRepeatController.text);
    toastNotification("Settings saved successfully.");
  }

  @override
  void initState() {
    super.initState();
    getSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: padding16,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  settingItem(
                    itemName: "Course length",
                    description:
                        "Course duration in minutes, used to set the schedule end time automatically.",
                    settingWidget: SmallInputField(
                        textEditingController: courseLengthController,
                        hintText: ""),
                    context: context,
                  ),
                  settingItem(
                    itemName: "Schedule repeat",
                    description:
                        "Sets how many times the schedule repeats weekly. Enter \"1\" for no repeats.",
                    settingWidget: SmallInputField(
                        textEditingController: scheduleRepeatController,
                        hintText: ""),
                    context: context,
                  ),
                ],
              ),
            ),
            SolidButton(
                action: () {
                  saveSettings();
                },
                text: "Save")
          ],
        ),
      ),
    );
  }

  Widget settingItem(
      {required String itemName,
      required String description,
      required Widget settingWidget,
      required BuildContext context}) {
    return ListTile(
      title: Text(
        itemName,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        description,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      trailing: settingWidget,
    );
  }
}
