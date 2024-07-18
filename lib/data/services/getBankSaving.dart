import 'package:dio/dio.dart';
import 'package:nvs_trading/data/model/info_bank_interest_rate.dart';

Dio _dio = Dio();

Future<List<BankInterestRateInfo>> GetBankSaving(
    String pBankCode, String pPerIod, String token) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.get(
      'http://192.168.2.55:9091/api/Bank-Saving/Get-Bank-Saving-Search?pBankCode=$pBankCode&pPerIod=$pPerIod',
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      final List<dynamic> rawData = response.data['data'];
      final List<BankInterestRateInfo> bankInterestRateInfo =
          rawData.map((e) => BankInterestRateInfo.fromJson(e)).toList();
      return bankInterestRateInfo;
    } else {
      print('${response.statusCode}');
      return [];
    }
  } catch (e) {
    print("Loi la: $e");
    return [];
  }
}
