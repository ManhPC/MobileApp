import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<Response> registerBankAccount(String bankAccount, String bankId,
    String branchBank, String custodycd, String fullName) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.post(
      'http://192.168.2.55:9090/Account/RegisterBankAccount',
      data: {
        'bankAccount': bankAccount,
        'bankId': bankId,
        'branchBank': branchBank,
        'custodycd': custodycd,
        'fullName': fullName,
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

Future<Response> deleteBankAccount(
    String bankAccount, String bankId, String custodycd) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.put(
      'http://192.168.2.55:9090/Account/DeleteRegisterBank',
      data: {
        'bankAccount': bankAccount,
        'bankId': bankId,
        'custodycd': custodycd,
      },
      options: Options(headers: headers),
    );
    return response;
  } catch (e) {
    return Future.error(e);
  }
}
