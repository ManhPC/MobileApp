import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<Response> getListCashTransfer(int from, int to, String Status,
    String CustodyCD, String Acctno, String StartDate, String EndDate) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final res = await _dio.get(
      'http://192.168.2.55:9090/Cash/GetListCashTransfer?from=$from&to=$to&Status=$Status&CustodyCD=$CustodyCD&Acctno=$Acctno&StartDate=$StartDate&EndDate=$EndDate',
      data: {
        'from': from,
        'to': to,
        'Status': Status,
        'CustodyCD': CustodyCD,
        'Acctno': Acctno,
        'StartDate': StartDate,
        'EndDate': EndDate,
      },
      options: Options(headers: headers),
    );

    return res;
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
