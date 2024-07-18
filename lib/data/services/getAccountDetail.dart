// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/model/get_account_detail.dart';

Dio _dio = Dio();

Future<List<GetAccountDetailModel>> GetAccountDetail(String custodycd) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.get(
      'http://192.168.2.55:9090/Cash/GetAccountDetail?Custodycd=$custodycd',
      data: {
        'custodycd': custodycd,
      },
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      final List<dynamic> rawData = response.data['data'];
      final List<GetAccountDetailModel> responseData =
          rawData.map((e) => GetAccountDetailModel.fromjson(e)).toList();
      return responseData;
    } else {
      print("${response.statusCode}");
      return [];
    }
  } catch (e) {
    print('Error: $e');
    return Future.error(e);
  }
}
