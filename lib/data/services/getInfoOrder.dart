import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/model/get_info_order.dart';

Dio _dio = Dio();

Future<List<InfoOrder>> GetInfoOrder(
    String acctno, String? symbol, double? price) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    String url = 'http://192.168.2.55:9090/Order/GetInfoOrder?Acctno=$acctno';
    if (symbol != null && symbol.isNotEmpty) {
      url += '&Symbol=$symbol';
    }
    if (price != null && price != 0) {
      url += '&Price=$price';
    }

    final response = await _dio.get(
      url,
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> rawData = response.data['data'];
      final data = InfoOrder.fromJson(rawData);
      return [data];
    } else {
      print(response.statusCode);
      return [];
    }
  } catch (e) {
    print(e);
    return Future.error(e);
  }
}
