import 'package:dio/dio.dart';

Dio _dio = Dio();

Future<int?> ChangeOTPMethod(
    String custodycd, String recvtype, String token) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.put(
      'http://192.168.2.55:9090/Account/ChangeOTPMethod',
      data: {
        'custodycd': custodycd,
        'recvtype': recvtype,
      },
      options: Options(headers: headers),
    );
    return response.statusCode;
  } catch (e) {
    print(e);
    return 0;
  }
}
