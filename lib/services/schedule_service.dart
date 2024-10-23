import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/schedule_note.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/services/config.dart';

class ScheduleService {
  Future<ScheduleList?> getScheduleList(
      {int? year, int? month, int? day}) async {
    ScheduleList? schedule;
    try {
      String url = '/schedules?';
      url += 'year=$year&month=$month';
      if (day != null) {
        url += '&day=$day';
      }
      Response response = await ServiceConfig().dio.get(url);
      schedule = ScheduleList.fromJson(response.data);
    } on DioException catch (e) {
      inspect(e);
    }
    return schedule;
  }

  Future<bool> createSchedule(Schedule schedule, {String? repeat}) async {
    Map<String, dynamic> params = schedule.toJson();
    params['studentId'] = params['student']['id'];
    params['teacherId'] = params['teacher']['id'];
    params['instrumentId'] = params['instrument']['id'];
    int repeatNumber = 4;
    if (repeat != null && repeat.isNotEmpty) {
      repeatNumber = int.parse(repeat);
    }
    try {
      Response response = await ServiceConfig()
          .dio
          .post('/schedules/$repeatNumber', data: params);
      inspect(response);
      if (response.statusCode != 200) {
        return false;
      }
      return true;
    } on DioException catch (e) {
      inspect(e);
      return false;
    }
  }

  Future<bool> updateSchedule(Schedule schedule) async {
    Map<String, dynamic> params = schedule.toJson();
    params['studentId'] = params['student']['id'];
    params['teacherId'] = params['teacher']['id'];
    params['instrumentId'] = params['instrument']['id'];
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

  Future<ScheduleNoteList?> getAllNotes(Schedule schedule) async {
    ScheduleNoteList? scheduleNoteList;
    try {
      Response response =
          await ServiceConfig().dio.get('/schedule_notes/${schedule.id}');
      scheduleNoteList = ScheduleNoteList.fromJson(response.data);
    } on DioException catch (e) {
      inspect(e);
    }
    return scheduleNoteList;
  }

  Future<bool> createNote(ScheduleNote note) async {
    Map<String, dynamic> params = note.toJson();
    try {
      Response response =
          await ServiceConfig().dio.post('/schedule_notes', data: params);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      inspect(e);
      return false;
    }
  }

  Future<bool> updateNote(ScheduleNote note) async {
    Map<String, dynamic> params = note.toJson();
    try {
      Response response = await ServiceConfig()
          .dio
          .put('/schedule_notes/schedule_note/${note.id}', data: params);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      inspect(e);
      return false;
    }
  }

  Future<bool> deleteNote(ScheduleNote note) async {
    try {
      Response response = await ServiceConfig()
          .dio
          .delete('/schedule_notes/schedule_note/${note.id}');
      inspect(response);
      return true;
    } on DioException catch (e) {
      inspect(e);
      return false;
    }
  }
}
