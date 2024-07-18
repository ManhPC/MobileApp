import 'package:dio/dio.dart';
import 'package:nvs_trading/data/model/customer_info.dart';

Dio _dio = Dio();
Future<List<CustomerInfo>> GetInfoCustomer(
    String custodycd, String token) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.get(
      'http://192.168.2.55:9090/Account/GetInfoCustomer?custodycd=$custodycd',
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      final List<dynamic> rawData = response.data['data'];
      List<CustomerInfo> responseDataList =
          rawData.map((rawData) => CustomerInfo.fromJson(rawData)).toList();
      return responseDataList;
    } else {
      print(response.statusCode);
      return [];
    }
  } catch (e) {
    print("Error: $e");
    return [];
  }
}
