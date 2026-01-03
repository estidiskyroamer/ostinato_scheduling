import 'package:dio/dio.dart';
import 'package:ostinato/common/components/components.dart';
import 'package:ostinato/models/instrument.dart';
import 'package:ostinato/services/config.dart';

class InstrumentService {
  Future<InstrumentList?> getInstruments() async {
    InstrumentList? instrumentList;
    try {
      Response response = await ServiceConfig().dio.get('/instruments');
      instrumentList = InstrumentList.fromJson(response.data);
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
    }
    return instrumentList;
  }
}
