import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();
Future<List<dynamic>> getRightBalanceInfo(int from, int to, String custodycd,
    String acctno, String symbol, String status, String caType) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {"Authorization": 'Bearer $token'};
    final response = await _dio.get(
      'http://192.168.2.55:9090/Role/GetRightbalanceInfo?from=$from&to=$to&Custodycd=$custodycd&Acctno=$acctno&Symbol=$symbol&status=$status&caType=$caType',
      data: {
        'from': from,
        'to': to,
        'Custodycd': custodycd,
        'Acctno': acctno,
        'Symbol': symbol,
        'status': status,
        'caType': caType,
      },
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      List<dynamic> rawData = response.data['data'];
      return rawData;
    } else {
      print(response.statusCode);
      return [];
    }
  } catch (e) {
    return Future.error(e);
  }
}
