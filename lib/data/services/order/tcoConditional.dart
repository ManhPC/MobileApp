import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<Response> tcoCon(
    String afAcctNo,
    String execType,
    String fromDate,
    int orderQtty,
    String price,
    String symbol,
    String toDate,
    String via) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.post(
      'http://192.168.2.55:9090/Order/TCOConditional',
      data: {
        'afAcctNo': afAcctNo,
        'execType': execType,
        'fromDate': fromDate,
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
