import 'package:dio/dio.dart';

Dio _dio = Dio();

Future<Response> getStockList(String symbol) {
  try {
    final response = _dio.get('https://api.apsi.vn:5003/pr/stockhist/$symbol');
    return response;
  } catch (e) {
    return Future.error(e);
  }
}
