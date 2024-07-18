import 'package:dio/dio.dart';
import 'package:nvs_trading/data/model/forget_username.dart';

Dio _dio = Dio();
Future<List<ForgotUsername>> forgotUserName(
    String idCode, String otpId, String otpCode, String phone) async {
  try {
    final response = await _dio
        .put('http://192.168.2.55:9090/Account/ForgotUserName', data: {
      'idCode': idCode,
      'otpId': otpId,
      'otpCode': otpCode,
      'phone': phone,
    });
    if (response.statusCode == 200) {
      final Map<String, dynamic> rawData = response.data['data'];
      // Tạo một đối tượng OTPnoAuth từ dữ liệu 'data'
      ForgotUsername accountModel = ForgotUsername.fromJson(rawData);
      // Trả về một danh sách chỉ chứa một đối tượng OTPnoAuth

      return [accountModel];
    } else {
      print('Data key not found in response.');
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
}
