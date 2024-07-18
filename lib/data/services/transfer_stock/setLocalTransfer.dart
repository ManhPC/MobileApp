import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<List<dynamic>> setLocalTransfer(String acctno, String description,
    String quanityTranfer, String recvAcctno, String symbol) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final res = await _dio.post(
      'http://192.168.2.55:9090/TradingStock/SecLocalTranfer',
      data: {
        'acctno': acctno,
        'description': description,
        'quanityTranfer': quanityTranfer,
        'recvAcctno': recvAcctno,
        'symbol': symbol,
      },
      options: Options(headers: headers),
    );
    if (res.statusCode == 200) {
      final rawData = res.data;
      return [rawData];
    } else {
      print(res.statusCode);
      return [];
    }
  } catch (e) {
    if (e is DioError) {
      print('DioError caught: ${e.response!.data}');
      if (e.response!.data != null) {
        return [e.response!.data];
      } else {
        return Future.error('Unexpected error: ${e.message}');
      }
    } else {
      return Future.error(e);
    }
  }
}
