import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/teacher.dart';
import 'package:ostinato/common/config.dart';
import 'dart:developer';

import 'package:ostinato/services/config.dart';

class ScheduleService {
  Future<GroupedSchedule?> getGroupedSchedule({int? month, int? year}) async {
    GroupedSchedule? schedule;
    try {
      String url = '/schedules';
      if (month != null && year != null) {
        url += '/$month/$year';
      }
      Response response = await ServiceConfig().dio.get(url);
      schedule = GroupedSchedule.fromJson(response.data);
    } on DioException catch (e) {
      inspect(e);
    }
    return schedule;
  }

  Future<bool> createSchedule(Schedule schedule, {String? repeat}) async {
    Map<String, dynamic> params = schedule.toJson();
    bool success = true;
    int repeatNumber = 4;
    inspect(repeat);
    if (repeat != null && repeat.isNotEmpty) {
      repeatNumber = int.parse(repeat);
    }
    for (int i = 0; i < repeatNumber; i++) {
      try {
        int addedDays = 7 * i;
        DateTime newDate = schedule.date.add(Duration(days: addedDays));
        params['date'] = DateFormat('yyyy-MM-dd').format(newDate);
        Response response =
            await ServiceConfig().dio.post('/schedules', data: params);
        inspect(response);
        if (response.statusCode != 200) {
          success = false;
          break;
        }
      } on DioException catch (e) {
        inspect(e);
        success = false;
        break;
      }
    }
    return success;
  }

  Future<bool> updateSchedule(Schedule schedule) async {
    Map<String, dynamic> params = schedule.toJson();
    try {
      Response response = await ServiceConfig()
          .dio
          .put('/schedules/schedule/${schedule.id}', data: params);
      inspect(response);
      return true;
    } on DioException catch (e) {
      inspect(e);
      return false;
    }
  }

  Future<bool> deleteSchedule(Schedule schedule) async {
    try {
      Response response = await ServiceConfig()
          .dio
          .delete('/schedules/schedule/${schedule.id}');
      inspect(response);
      return true;
    } on DioException catch (e) {
      inspect(e);
      return false;
    }
  }
}
