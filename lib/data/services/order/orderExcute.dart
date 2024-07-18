// ignore_for_file: non_constant_identifier_names, file_names

import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<List<dynamic>> OrderExcute(String accTno, String orderType,
    String passTransfer, String price, int quantity, String stockSymbol) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.post(
      'http://192.168.2.55:9090/Order/OrderExcute',
      data: {
        'accTno': accTno,
        'orderType': orderType,
        'passTransfer': passTransfer,
        'price': price,
        'quantity': quantity,
        'stockSymbol': stockSymbol,
      },
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      final rawData = response.data['listResult'];
      return rawData;
    } else {
      print("a");
      return [
        response.statusCode,
        response.statusMessage,
      ];
    }
  } catch (e) {
    if (e is DioError) {
      print('DioError caught: ${e.response}');
      if (e.response != null) {
        return [
          e.response!.statusCode,
          e.response!.data['message'],
        ];
      } else {
        return Future.error('Unexpected error: ${e.message}');
      }
    } else {
      return Future.error(e);
    }
  }
}
