import 'package:dio/dio.dart';

Dio _dio = Dio();

Future<int?> updateSmsSetting(
    String code, String custodycd, String token) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.post(
      'http://192.168.2.55:9090/SmsSetting/Update',
      data: {
        'code': code,
        'custodycd': custodycd,
      },
      options: Options(headers: headers),
    );
    return response.statusCode;
  } catch (e) {
    print("Ma loi: $e");
    return 0;
  }
}
