import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<int> setDefaultAcctno(String acctno, String tlname) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final res = await _dio.post(
      'http://192.168.2.55:9090/Account/Set-Default-Acctno',
      data: {
        'acctno': acctno,
        'tlname': tlname,
      },
      options: Options(headers: headers),
    );
    if (res.statusCode == 200) {
      return res.data['errorCode'];
    } else {
      return -1;
    }
  } catch (e) {
    return Future.error(e);
  }
}
