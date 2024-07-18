import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<String> payLoan(String acctno, String loanid, int amount) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.put(
      'http://192.168.2.55:9090/Cash/PayLoan',
      data: {
        'acctno': acctno,
        'loanid': loanid,
        'amount': amount,
      },
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      final rawData = response.data['message'];
      return rawData;
    } else {
      return "";
    }
  } catch (e) {
    if (e is DioError) {
      if (e.response!.data['message'] != null) {
        return e.response!.data['message'];
      } else {
        return Future.error('Unexpected error: ${e.message}');
      }
    } else {
      return Future.error(e);
    }
  }
}
