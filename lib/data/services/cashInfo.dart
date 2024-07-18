import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/model/cash_info.dart';

Dio _dio = Dio();

Future<List<CashInfoModel>> getCashInfo(String custodycd, String acctno) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.get(
      'http://192.168.2.55:9090/Assets/CashInfo?custodycd=$custodycd&acctno=$acctno',
      data: {
        'custodycd': custodycd,
        'acctno': acctno,
      },
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      final List<dynamic> rawData = response.data['data'];
      List<CashInfoModel> rs =
          rawData.map((value) => CashInfoModel.fromJson(value)).toList();
      return rs;
    } else {
      print(response.statusCode);
      return [];
    }
  } catch (e) {
    return Future.error(e);
  }
}
