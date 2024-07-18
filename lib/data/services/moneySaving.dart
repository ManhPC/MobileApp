import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/model/money_saving_model.dart';

Dio _dio = Dio();

Future<List<MoneySavingModel>> getMoneySaving(
    String pCustodyCd,
    String pAfacctno,
    String pFromDate,
    String pToDate,
    String pBankSavingCode,
    String pStatus,
    String pFrom,
    String pTo) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.get(
      'http://192.168.2.55:9091/api/Money-Saving/Get-Money-Saving-Search?pCustodyCd=$pCustodyCd&pAfacctno=$pAfacctno&pFromDate=$pFromDate&pToDate=$pToDate&pBankSavingCode=$pBankSavingCode&pStatus=$pStatus&pFrom=$pFrom&pTo=$pTo',
      data: {
        'pCustodyCd': pCustodyCd,
        'pAfacctno': pAfacctno,
        'pFromDate': pFromDate,
        'pToDate': pToDate,
        'pBankSavingCode': pBankSavingCode,
        'pStatus': pStatus,
        'pFrom': pFrom,
        'pTo': pTo,
      },
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      final List<dynamic> rawData = response.data['data'];
      final List<MoneySavingModel> moneyData =
          rawData.map((e) => MoneySavingModel.fromJson(e)).toList();
      return moneyData;
    } else {
      print("${response.statusCode}");
      return [];
    }
  } catch (e) {
    print("Error : $e");
    return [];
  }
}

Future<Response> WithdrawMoneyBeforePeriod(
    String brId, String savingId, String tlId) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final res = await _dio.post(
      'http://192.168.2.55:9091/api/Money-Saving/Withdraw-Money-Befor-PerIod',
      data: {
        'brId': brId,
        'savingId': savingId,
        'tlId': tlId,
      },
      options: Options(headers: headers),
    );
    return res;
  } catch (e) {
    return Future.error(e);
  }
}

Future<Response> RefuseMoneySaving(String pSavingId, String pAfacctno) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.delete(
      'http://192.168.2.55:9091/api/Money-Saving/Refuse-Money-Saving?pSavingId=$pSavingId&pAfacctno=$pAfacctno',
      data: {
        'pSavingId': pSavingId,
        'pAfacctno': pAfacctno,
      },
      options: Options(headers: headers),
    );
    return response;
  } catch (e) {
    print(e);
    return Future.error(e);
  }
}
