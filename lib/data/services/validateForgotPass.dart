// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'package:dio/dio.dart';

Dio _dio = Dio();

Future<Response<dynamic>?> ValidateForgotPass(
    String custodycd, String idCode) async {
  try {
    final response = await _dio
        .post('http://192.168.2.55:9090/Account/ValidateForgotPass', data: {
      "custodycd": custodycd,
      "idCode": idCode,
    });
    return response;
  } catch (error) {
    if (error is DioError && error.response != null) {
      return error.response!;
    } else {
      print("Mã lỗi: $error");
      rethrow;
    }
  }
}
