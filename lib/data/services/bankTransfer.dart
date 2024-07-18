import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<Response> bankTransfer(
    String acctno,
    String bankAccTno,
    String bankId,
    String feeType,
    String moneyTranfer,
    String note,
    String otpCode,
    String otpId) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.post(
      'http://192.168.2.55:9090/Cash/BankTranfer',
      data: {
        'acctno': acctno,
        'bankAccTno': bankAccTno,
        'bankId': bankId,
        'feeType': feeType,
        'moneyTranfer': moneyTranfer,
        'note': note,
        'otpCode': otpCode,
        'otpId': otpId,
      },
      options: Options(headers: headers),
    );
    return response;
  } catch (e) {
    return Future.error(e);
  }
}
