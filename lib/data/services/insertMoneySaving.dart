import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<Response> InsertMoneySaving(
    String afacctno,
    int balance,
    String bankSavingCode,
    String brId,
    String custId,
    String hinhThucDaoHan,
    String period,
    String tlId) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.post(
      'http://192.168.2.55:9091/api/Money-Saving/Insert-Money-Saving',
      data: {
        'afacctno': afacctno,
        'balance': balance,
        'bankSavingCode': bankSavingCode,
        'brId': brId,
        'custId': custId,
        'hinhThucDaoHan': hinhThucDaoHan,
        'period': period,
        'tlId': tlId,
      },
      options: Options(headers: headers),
    );
    return response;
  } catch (e) {
    print(e);
    return Future.error(e);
  }
}
