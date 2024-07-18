import 'package:dio/dio.dart';

Dio _dio = Dio();

Future<Response> getRatio(String symbol) {
  try {
    final res = _dio.get('https://api.apsi.vn:8091/api/GetRatio/$symbol');
    return res;
  } catch (e) {
    return Future.error(e);
  }
}
