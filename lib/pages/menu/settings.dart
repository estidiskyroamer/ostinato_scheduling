import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ostinato/common/components/buttons.dart';
import 'package:ostinato/common/components/components.dart';
import 'package:ostinato/common/components/input_field.dart';
import 'package:ostinato/common/components/theme_extension.dart';
import 'package:ostinato/common/components/theme_provider.dart';
import 'package:ostinato/common/config.dart';
import 'package:ostinato/models/settings.dart';
import 'package:ostinato/services/settings_service.dart';
import 'package:ostinato/services/theme_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController courseLengthController = TextEditingController();
  TextEditingController scheduleRepeatController = TextEditingController();

  ScheduleSettings? settings;

  late String courseLength;
  late String repeat;

  void getSettings() async {
    ScheduleSettings? result = await SettingsService().loadScheduleSettings();
    if (result != null) {
      if (mounted) {
        setState(() {
          settings = result;
          courseLengthController.text = settings!.lessonLength;
          scheduleRepeatController.text = settings!.repeat;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          settings = result;
          courseLengthController.text = Config().courseLengthDef.toString();
          scheduleRepeatController.text = Config().repeatDef.toString();
        });
      }
    }
  }

  void saveSettings() async {
    await Config().storage.write(key: 'course_length', value: courseLengthController.text);
    await Config().storage.write(key: 'repeat', value: scheduleRepeatController.text);
    toastNotification("Settings saved successfully.");
  }

  void showThemeBottomSheet() {
    ThemeService themeService = ThemeProvider.read(context);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ItemBottomSheet(
          child: Column(
            children: [
              Text(
                "Select Theme",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontStyle: FontStyle.italic),
              ),
              Row(
                children: [
                  RowIconButton(
                    onTap: () {
                      themeService.setThemeMode(ThemeMode.system);
                      Navigator.pop(context);
                    },
                    icon: LucideIcons.smartphone,
                    label: "System",
                  ),
                  RowIconButton(
                    onTap: () {
                      themeService.setThemeMode(ThemeMode.light);
                      Navigator.pop(context);
                    },
                    icon: LucideIcons.sun,
                    label: "Light",
                  ),
                  RowIconButton(
                    onTap: () {
                      themeService.setThemeMode(ThemeMode.dark);
                      Navigator.pop(context);
                    },
                    icon: LucideIcons.moon,
                    label: "Dark",
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getSettings();
  }

  @override
  Widget build(BuildContext context) {
    ThemeService themeService = ThemeProvider.of(context);

    return Scaffold(
      appBar: AppBar(
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
                    description: "Course duration in minutes, used to set the schedule end time automatically.",
                    settingWidget: SmallInputField(textEditingController: courseLengthController, hintText: ""),
                    context: context,
                  ),
                  settingItem(
                    itemName: "Schedule repeat",
                    description: "Sets how many times the schedule repeats weekly. Enter \"1\" for no repeats.",
                    settingWidget: SmallInputField(textEditingController: scheduleRepeatController, hintText: ""),
                    context: context,
                  ),
                  settingItem(
                    itemName: "Theme",
                    description: "Choose between system, light, or dark theme.",
                    settingWidget: GestureDetector(
                      onTap: showThemeBottomSheet,
                      child: Container(
                        padding: padding8,
                        child: Text(
                          themeService.getThemeDisplayName(themeService.themeMode),
                          style: Theme.of(context).textTheme.labelMedium,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
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

  Widget settingItem({required String itemName, required String description, required Widget settingWidget, required BuildContext context}) {
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
