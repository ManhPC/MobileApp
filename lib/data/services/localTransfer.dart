import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<Response> LocalTransfer(
    String acctno, String moneyTransfer, String note, String recvAcctno) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.post(
      'http://192.168.2.55:9090/Cash/LocalTranfer',
      data: {
        'acctno': acctno,
        'moneyTranfer': moneyTransfer,
        'note': note,
        'recvAcctno': recvAcctno,
      },
      options: Options(headers: headers),
    );
    return response;
  } catch (e) {
    if (e is DioError) {
      print('DioError caught: ${e.response}');
      if (e.response != null) {
        return e.response!;
      } else {
        return Future.error('Unexpected error: ${e.message}');
      }
    } else {
      return Future.error(e);
    }
  }
}
