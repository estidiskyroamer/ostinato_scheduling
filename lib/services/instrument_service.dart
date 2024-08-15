import 'package:dio/dio.dart';
import 'package:ostinato/models/instrument.dart';
import 'package:ostinato/models/student.dart';
import 'package:ostinato/common/config.dart';
import 'dart:developer';

class InstrumentService {
  String baseUrl = Config().baseUrl;

  Future<InstrumentList?> getInstruments() async {
    InstrumentList? instrumentList;
    try {
      Response response = await Config().dio.get('$baseUrl/instruments');
      instrumentList = InstrumentList.fromJson(response.data);
    } on DioException catch (e) {
      inspect(e);
    }
    return instrumentList;
  }
}
