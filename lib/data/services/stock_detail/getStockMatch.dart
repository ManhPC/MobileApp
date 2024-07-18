import 'package:dio/dio.dart';

Dio _dio = Dio();

Future<Response> getStockMatch(String symbol, String lastTicks) {
  try {
    final res = _dio.get(
        'https://api.apsi.vn:5003/pr/stockmatch/$symbol?lastTicks=$lastTicks');
    return res;
  } catch (e) {
    return Future.error(e);
  }
}
