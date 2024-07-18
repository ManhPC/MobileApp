// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';

Dio _dio = Dio();

Future<List<dynamic>> GetAllCode(
    String CDTYPE, String CDCODE, String token) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.get(
      'http://192.168.2.55:9090/HomeMobile/GetAllCode?CDTYPE=$CDTYPE&CDCODE=$CDCODE',
      options: Options(
        headers: headers,
      ),
    );
    if (response.statusCode == 200) {
      List<dynamic> rawData = response.data['data'];
      return rawData;
    } else {
      print("Failed: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print("Error fetching data: $e");
    return [];
  }
}
