import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<Response> PROCOMconditional(
  String acctno,
  String date,
  String execType,
  int orderQtty,
  String symbol,
  String via,
) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.post(
      'http://192.168.2.55:9090/Order/PriorityOrder',
      data: {
        'acctno': acctno,
        'date': date,
        'execType': execType,
        'orderQtty': orderQtty,
        'symbol': symbol,
        'via': via,
      },
      options: Options(
        headers: headers,
      ),
    );
    return response;
  } catch (e) {
    return Future.error(e);
  }
}
