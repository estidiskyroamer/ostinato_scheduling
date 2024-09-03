import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ostinato/models/summary.dart';
import 'package:ostinato/services/config.dart';

class SummaryService {
  Future<Summary?> getSummary() async {
    Summary? summary;
    try {
      Response response = await ServiceConfig().dio.get('/summary');
      summary = Summary.fromJson(response.data);
    } on DioException catch (e) {
      inspect(e);
    }
    return summary;
  }
}
