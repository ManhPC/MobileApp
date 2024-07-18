import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<List<dynamic>> getBuyingPower(String AccTno, String RecvAcctno) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    List<String> data = [];
    data.add('AccTno=$AccTno');
    if (RecvAcctno.isNotEmpty) {
      data.add('RecvAcctno=$RecvAcctno');
    }
    String queryString = data.join('&');
    final response = await _dio.get(
      'http://192.168.2.55:9090/TradingStock/CheckBuyingPower?$queryString',
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      final rawData = response.data['data'];
      return [rawData];
    } else {
      print(response.statusCode);
      return [];
    }
  } catch (e) {
    return Future.error(e);
  }
}
