import 'package:dio/dio.dart';

Dio _dio = Dio();

Future<Response> GetBusDate(String token) {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final res = _dio.get(
      'http://192.168.2.55:9090/HomeMobile/GetBusDate',
      options: Options(headers: headers),
    );
    return res;
  } catch (e) {
    print("$e");
    rethrow;
  }
}
