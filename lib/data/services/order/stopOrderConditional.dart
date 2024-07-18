import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<Response> stopOrderCon(
  String afAcctNo,
  String condition,
  String execType,
  String executePrice,
  int orderQtty,
  String price,
  String symbol,
  String toDate,
  String via,
) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.post(
      'http://192.168.2.55:9090/Order/StopOrderConditional',
      data: {
        'afAcctNo': afAcctNo,
        'condition': condition,
        'execType': execType,
        'executePrice': executePrice,
        'orderQtty': orderQtty,
        'price': price,
        'symbol': symbol,
        'toDate': toDate,
        'via': via,
      },
      options: Options(headers: headers),
    );
    return response;
  } catch (e) {
    return Future.error(e);
  }
}
