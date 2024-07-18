import 'package:dio/dio.dart';

Dio _dio = Dio();

Future<List<dynamic>> GetList(String custodycd, String token) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.get(
      'http://192.168.2.55:9090/ProfitLossWarning/GetList?custodycd=$custodycd',
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      final List<dynamic> rawData = response.data['data'];
      return rawData;
    } else {
      print('Loi la: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
}

Future<int?> removeWarning(String autoid, String token) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.put(
      'http://192.168.2.55:9090/ProfitLossWarning/Remove?autoid=$autoid',
      queryParameters: {
        'autoid': autoid,
      },
      options: Options(headers: headers),
    );
    return response.statusCode;
  } catch (e) {
    print(e);
    return 0;
  }
}

Future<int?> updateWarning(String acctno, String autoid, String custodycd,
    int lossRate, int profitRate, String token) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.post(
      'http://192.168.2.55:9090/ProfitLossWarning/Edit',
      data: {
        'acctno': acctno,
        'autoid': autoid,
        'custodycd': custodycd,
        'lossRate': lossRate,
        'profitRate': profitRate,
      },
      options: Options(headers: headers),
    );
    return response.statusCode;
  } catch (e) {
    print(e);
    return 0;
  }
}
