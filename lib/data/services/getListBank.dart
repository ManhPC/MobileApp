import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/model/list_bank.dart';

Dio _dio = Dio();

Future<List<ListBank>> getListBank() async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.get(
      'http://192.168.2.55:9090/Account/GetListBank',
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      final List<dynamic> rawData = response.data['data'];
      final List<ListBank> lB =
          rawData.map((e) => ListBank.fromJson(e)).toList();
      return lB;
    } else {
      print(response.statusCode);
      return [];
    }
  } catch (e) {
    return Future.error(e);
  }
}
