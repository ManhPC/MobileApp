import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<String> validateBankTransfer(String acctno, String bankAccTno,
    String bankId, String moneyTranfer) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.post(
      'http://192.168.2.55:9090/Cash/ValidateBankTranfer',
      data: {
        'acctno': acctno,
        'bankAccTno': bankAccTno,
        'bankId': bankId,
        'moneyTranfer': moneyTranfer,
      },
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      return response.data['message'];
    } else {
      return "";
    }
  } catch (e) {
    if (e is DioError) {
      print('DioError caught: ${e.response}');
      if (e.response != null) {
        return e.response!.data['message'];
      } else {
        return Future.error('Unexpected error: ${e.message}');
      }
    } else {
      return Future.error(e);
    }
  }
}
