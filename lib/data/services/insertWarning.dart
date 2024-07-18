import 'package:dio/dio.dart';

Dio _dio = Dio();

Future<int?> InsertWarning(String acctno, String custodycd, String lossRate,
    String profitRate, String? symbol, String type, String token) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};

    var data = {
      'acctno': acctno,
      'custodycd': custodycd,
      'lossRate': lossRate,
      'profitRate': profitRate,
      'type': type,
    };

    if (symbol != null) {
      data['symbol'] = symbol;
    }

    final response = await _dio.post(
      'http://192.168.2.55:9090/ProfitLossWarning/Insert',
      data: data,
      options: Options(
        headers: headers,
      ),
    );
    if (response.statusCode == 200) {
      // Thành công
      return response.statusCode;
    } else {
      // Lỗi
      print('Error: ${response.statusCode}');
      return null; // hoặc trả về một giá trị khác để biết được lỗi cụ thể
    }
  } catch (error) {
    print('Error: $error');
    return null;
  }
}
