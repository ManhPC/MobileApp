import 'package:dio/dio.dart';
import 'package:nvs_trading/data/model/generalOTPinfo.dart';

final Dio _dio = Dio();

Future<List<OTPInfo>> generalOTPnoAuth(
    String p1, String p2, String p3, String p4) async {
  try {
    final response = await _dio.post(
      'http://192.168.2.55:9090/HomeMobile/GenerateOTPNoAuth',
      data: {
        'p1': p1,
        'p2': p2,
        'p3': p3,
        'p4': p4,
      },
    );
    if (response.statusCode == 200 && response.data.containsKey('data')) {
      final Map<String, dynamic> rawData = response.data['data'];
      OTPInfo otpnoAuth = OTPInfo.fromJson(rawData);
      print(otpnoAuth.otpId);
      return [otpnoAuth];
    } else {
      print('Data key not found in response.');
      return [];
    }
  } catch (error) {
    print("Lỗi là: $error");
    return [];
  }
}
