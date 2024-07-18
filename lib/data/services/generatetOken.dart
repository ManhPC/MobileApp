import 'package:dio/dio.dart';
import 'package:nvs_trading/data/model/login.dart';

Dio _dio = Dio();

Future<List<LoginModel>> GeneratetOken(String username, String password) async {
  try {
    final response = await _dio.post(
      'http://192.168.2.55:9090/HomeMobile/GeneratetOken',
      data: {
        'username': username,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> rawData = response.data;
      LoginModel loginData = LoginModel.fromJson(rawData);
      // print(loginData.token);
      return [loginData];
    } else {
      print('Data not found');
      return [];
    }
  } catch (error) {
    print("Lỗi là: $error");
    return [];
  }
}
