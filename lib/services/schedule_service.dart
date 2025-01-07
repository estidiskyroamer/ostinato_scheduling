import 'package:dio/dio.dart';
import 'package:ostinato/common/components/component.dart';
import 'package:ostinato/models/schedule.dart';
import 'package:ostinato/models/schedule_note.dart';
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
      toastNotification(e.response!.data['errors'][0]);
    }
    return schedule;
  }

  Future<bool> createSchedule(Schedule schedule, {String? repeat}) async {
    Map<String, dynamic> params = schedule.toJson();
    params['studentId'] = params['student']['id'];
    params['teacherId'] = params['teacher']['id'];
    params['instrumentId'] = params['instrument']['id'];
    int repeatNumber =
        (repeat != null && repeat.isNotEmpty && int.tryParse(repeat) != null)
            ? (int.parse(repeat) < 1 ? 1 : int.parse(repeat))
            : 1;
    try {
      Response response = await ServiceConfig()
          .dio
          .post('/schedules/$repeatNumber', data: params);
      if (response.statusCode != 200) {
        return false;
      }
      toastNotification(response.data['message']);
      return true;
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
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
      toastNotification(response.data['message']);
      return true;
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
      return false;
    }
  }

  Future<bool> deleteSchedule(Schedule schedule) async {
    try {
      Response response = await ServiceConfig()
          .dio
          .delete('/schedules/schedule/${schedule.id}');
      toastNotification(response.data['message']);
      return true;
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
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
      toastNotification(e.response!.data['errors'][0]);
    }
    return scheduleNoteList;
  }

  Future<bool> createNote(ScheduleNote note) async {
    Map<String, dynamic> params = note.toJson();
    try {
      Response response =
          await ServiceConfig().dio.post('/schedule_notes', data: params);
      if (response.statusCode == 200) {
        toastNotification(response.data['message']);
        return true;
      }
      return false;
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
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
        toastNotification(response.data['message']);
        return true;
      }
      return false;
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
      return false;
    }
  }

  Future<bool> deleteNote(ScheduleNote note) async {
    try {
      Response response = await ServiceConfig()
          .dio
          .delete('/schedule_notes/schedule_note/${note.id}');
      toastNotification(response.data['message']);
      return true;
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
      return false;
    }
  }
}
