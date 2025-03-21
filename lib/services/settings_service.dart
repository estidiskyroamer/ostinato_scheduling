import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ostinato/common/components/components.dart';
import 'package:ostinato/models/settings.dart';
import 'package:ostinato/services/config.dart';

class SettingsService {
  Future<Settings?> getSettings() async {
    Settings? settings;
    try {
      Response response = await ServiceConfig().dio.get('/settings');

      Map<String, dynamic> data = response.data['data'];
      Map<String, dynamic> settingsJson = jsonDecode(data['settings']);
      settings = Settings.fromJson(settingsJson);
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
    }
    return settings;
  }
}
