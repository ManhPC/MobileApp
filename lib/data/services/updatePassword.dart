import 'package:dio/dio.dart';

Dio _dio = Dio();

Future<int?> updatePassword(
    String custodycd, String newPass, String otpCode, String otpId) async {
  try {
    final res = await _dio
        .put("http://192.168.2.55:9090/Account/UpdatePassword", data: {
      "custodycd": custodycd,
      "newPassword": newPass,
      "otpCode": otpCode,
      "otpId": otpId,
    });
    return res.statusCode;
  } catch (e) {
    print("Mã lỗi: $e");
    return 0;
  }
}
