import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<Response> checkFivePercent(
    String accTno, String orderType, int quantity, String stockSymbol) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.post(
      'http://192.168.2.55:9090/Order/CheckFivePercent',
      data: {
        'accTno': accTno,
        'orderType': orderType,
        'quantity': quantity,
        'stockSymbol': stockSymbol,
      },
      options: Options(headers: headers),
    );
    return response;
  } catch (e) {
    return Future.error(e);
  }
}
