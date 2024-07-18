import 'package:dio/dio.dart';
import 'package:nvs_trading/data/model/partner_bank.dart';

Dio _dio = Dio();

Future<List<PartnerBankModel>> GetPartnerBank(String token) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.get(
      'http://192.168.2.55:9091/api/Bank-Saving/Get-Partner-Bank',
      options: Options(
        headers: headers,
      ),
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.data['data'];
      final List<PartnerBankModel> partnerBanks =
          responseData.map((data) => PartnerBankModel.fromJson(data)).toList();
      return partnerBanks;
    } else {
      print('${response.statusCode}');
      return [];
    }
  } catch (e) {
    print("Error: $e");
    return [];
  }
}
