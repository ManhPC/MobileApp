import 'package:dio/dio.dart';
import 'package:nvs_trading/data/model/generalOTPinfo.dart';

final Dio _dio = Dio();

Future<List<OTPInfo>> generalOTPAuth(
    String p1, String p2, String p3, String p4, String token) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.post(
      'http://192.168.2.55:9090/HomeMobile/GenerateOTP',
      data: {
        'p1': p1,
        'p2': p2,
        'p3': p3,
        'p4': p4,
      },
      options: Options(headers: headers),
    );
    if (response.statusCode == 200 && response.data.containsKey('data')) {
      final Map<String, dynamic> rawData = response.data['data'];
      OTPInfo otpAuth = OTPInfo.fromJson(rawData);
      print(otpAuth.otpId);
      return [otpAuth];
    } else {
      print('Data key not found in response.');
      return [];
    }
  } catch (error) {
    print("Lỗi là: $error");
    return [];
  }
}
