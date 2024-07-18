import 'package:dio/dio.dart';

Dio _dio = Dio();

Future<List<dynamic>> GetSMSSettingList(String custodycd, String token) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.get(
      'http://192.168.2.55:9090/SmsSetting/GetList?custodycd=$custodycd',
      options: Options(
        headers: headers,
      ),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = response.data['data'];
      return data;
    } else {
      print(response.statusCode);
      return [];
    }
  } catch (e) {
    print("Err : $e");
    return [];
  }
}
