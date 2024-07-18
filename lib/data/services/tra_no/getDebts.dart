import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<List<dynamic>> getDebts(String custodycd, String Acctno) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final res = await _dio.get(
      'http://192.168.2.55:9090/Assets/GetDebts?Custodycd=$custodycd&Acctno=$Acctno',
      data: {
        'custodycd': custodycd,
        'Acctno': Acctno,
      },
      options: Options(headers: headers),
    );
    if (res.statusCode == 200) {
      final rawData = res.data['data'];
      return [rawData];
    } else {
      print(res.statusCode);
      return [];
    }
  } catch (e) {
    return Future.error(e);
  }
}
