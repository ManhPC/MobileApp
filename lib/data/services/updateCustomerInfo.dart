// ignore_for_file: non_constant_identifier_names, avoid_print, file_names

import 'package:dio/dio.dart';

Dio _dio = Dio();

Future<Response> UpdateCusInfo(String custodycd, String address, String phone,
    String email, String token) async {
  try {
    final Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
    };
    final response = await _dio.put(
      'http://192.168.2.55:9090/Account/UpdateCustomerInfo',
      data: {
        'custodycd': custodycd,
        'address': address,
        'phone': phone,
        'email': email,
      },
      options: Options(headers: headers),
    );
    return response;
  } catch (e) {
    print("Error: $e");
    rethrow;
  }
}
