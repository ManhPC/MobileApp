import 'package:dio/dio.dart';

Dio _dio = Dio();

Future<Response> getEventChart(String symbol) {
  try {
    final res = _dio.get('https://api.apsi.vn:8091/api/GetEventChart/$symbol');
    return res;
  } catch (e) {
    return Future.error(e);
  }
}
