import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ostinato/models/settings.dart';
import 'package:ostinato/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  Future<Settings?> getSettings() async {
    Settings? settings;
    try {
      Response response = await ServiceConfig().dio.get('/settings');

      Map<String, dynamic> data = response.data['data'];
      Map<String, dynamic> settingsJson = jsonDecode(data['settings']);
      settings = Settings.fromJson(settingsJson);
      saveScheduleSettings(settings.scheduleSettings);
    } on DioException catch (e) {
      inspect(e);
      // toastNotification(e.response!.data['errors'][0]);
    }
    return settings;
  }

  Future<void> saveScheduleSettings(ScheduleSettings scheduleSettings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'scheduleSettings',
        jsonEncode({
          'repeat': scheduleSettings.repeat,
          'lessonLength': scheduleSettings.lessonLength,
          'scheduleEndTime': scheduleSettings.scheduleEndTime,
          'scheduleStartTime': scheduleSettings.scheduleStartTime,
        }));
  }

  Future<ScheduleSettings?> loadScheduleSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? scheduleJson = prefs.getString('scheduleSettings');

    if (scheduleJson != null) {
      Map<String, dynamic> jsonMap = jsonDecode(scheduleJson);
      return ScheduleSettings.fromJson(jsonMap);
    }
    return null;
  }
}
