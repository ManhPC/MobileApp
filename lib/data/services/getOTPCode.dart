import 'package:dio/dio.dart';

Dio _dio = Dio();

Future<String> getOTPCode(String otpId) async {
  try {
    final response = await _dio
        .get('http://192.168.2.55:9090/HomeMobile/GetOTPCode?otpId=$otpId');
    if (response.statusCode == 200) {
      return response.data["data"]["otpCode"];
    } else {
      print("Lỗi không tìm được otpCode");
      return "";
    }
  } catch (e) {
    print(e);
    return "";
  }
}
