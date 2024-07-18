import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/model/bank_acctno_info.dart';

Dio _dio = Dio();

Future<List<BankAcctnoInfo>> getBankAcctnoInfo(
    String acctno, String bankId, String bankAccount) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.get(
      'http://192.168.2.55:9090/Cash/GetBankAcctnoInfo?Acctno=$acctno&bankid=$bankId&bankaccount=$bankAccount',
      data: {
        'Acctno': acctno,
        'bankId': bankId,
        'bankaccount': bankAccount,
      },
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      final List<dynamic> rawData = response.data['data'];
      final List<BankAcctnoInfo> bankAI =
          rawData.map((e) => BankAcctnoInfo.fromJson(e)).toList();
      return bankAI;
    } else {
      print(response.statusCode);
      return [];
    }
  } catch (e) {
    return Future.error(e);
  }
}
