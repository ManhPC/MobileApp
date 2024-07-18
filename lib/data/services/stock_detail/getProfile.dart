import 'package:dio/dio.dart';

Dio _dio = Dio();

Future<Response> getProfile(String symbol) {
  try {
    final res = _dio.get('https://api.apsi.vn:8091/api/GetProfile/$symbol');
    return res;
  } catch (e) {
    return Future.error(e);
  }
}
