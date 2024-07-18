import 'package:dio/dio.dart';

Dio _dio = Dio();

Future<List<dynamic>> GetStockInfo(
    String custodycd, String acctno, String token) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.get(
      'http://192.168.2.55:9090/Assets/GetStockInfo?custodycd=$custodycd&acctno=$acctno',
      data: {
        'custodycd': custodycd,
        'acctno': acctno,
      },
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      List<dynamic> rawData = response.data["data"];
      return rawData;
    } else {
      print("Loi tum lum");
      return [];
    }
  } catch (e) {
    print("$e");
    return [];
  }
}
