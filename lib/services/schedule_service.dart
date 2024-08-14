import 'package:dio/dio.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/teacher.dart';
import 'package:ostinato/common/config.dart';
import 'dart:developer';

class ScheduleService {
  String baseUrl = Config().baseUrl;

  Future<GroupedSchedule?> getGroupedSchedule({int? month, int? year}) async {
    GroupedSchedule? schedule;
    try {
      String url = '$baseUrl/schedules';
      if (month != null && year != null) {
        url += '/$month/$year';
      }
      Response response = await Config().dio.get(url);
      schedule = GroupedSchedule.fromJson(response.data);
    } on DioException catch (e) {
      inspect(e);
    }
    return schedule;
  }
}
