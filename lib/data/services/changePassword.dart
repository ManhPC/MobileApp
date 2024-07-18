import 'package:dio/dio.dart';

Dio _dio = Dio();

Future<int?> ChangePassword(String otpId, String otpCode, String oldPassword,
    String newPassword, String confirmPassword, String token) async {
  try {
    Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final res = await _dio.put(
      "http://192.168.2.55:9090/Account/ChangePassword",
      data: {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "confirmPass": confirmPassword,
        "otpCode": otpCode,
        "otpId": otpId,
      },
      options: Options(headers: headers),
    );
    return res.statusCode;
  } catch (e) {
    print("Mã lỗi: $e");
    return 0;
  }
}
