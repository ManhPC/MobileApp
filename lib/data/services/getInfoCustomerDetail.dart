import 'package:dio/dio.dart';
import 'package:nvs_trading/data/model/account_info.dart';

Dio _dio = Dio();

Future<List<AccountInfoModel>> getInfoCustomerDetail(
    String token, String custodycd, String eddOver) async {
  try {
    // String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
    };
    final response = await _dio.get(
      'http://192.168.2.55:9090/Account/GetInfoCustomerDetail?custodycd=$custodycd&eddOver=$eddOver',
      queryParameters: {
        'custodycd': custodycd,
        'eddOver': eddOver,
      },
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> rawData = response.data['data'];
      AccountInfoModel responseData = AccountInfoModel.fromJson(rawData);
      return [responseData];
    } else {
      return [];
    }
  } catch (error) {
    print("Mã lỗi là: $error");
    return [];
  }
}
