import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<List<dynamic>> getSendInfo(String AccTno) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final res = await _dio.get(
      'http://192.168.2.55:9090/TradingStock/GetSendInfo?AccTno=$AccTno',
      data: {
        'AccTno': AccTno,
      },
      options: Options(headers: headers),
    );
    if (res.statusCode == 200) {
      final rawData = res.data;
      return [rawData];
    } else {
      return [];
    }
  } catch (e) {
    return Future.error(e);
  }
}
