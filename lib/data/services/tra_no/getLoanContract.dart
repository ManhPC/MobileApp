import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<List<dynamic>> getLoanContract(
  String Custodycd,
  String Acctno,
  String StartDate,
  String EndDate,
  String sort,
  int From,
  int To,
) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    List<String> data = [];
    data.add('Custodycd=$Custodycd');
    data.add('Acctno=$Acctno');
    if (StartDate.isNotEmpty) {
      data.add('Fromdate=$StartDate');
    }
    if (EndDate.isNotEmpty) {
      data.add('Todate=$EndDate');
    }
    if (sort.isNotEmpty && sort != "null") {
      data.add('sort=$sort');
    }

    data.add('from=$From');

    data.add('to=$To');

    String queryString = data.join('&');
    final res = await _dio.get(
      'http://192.168.2.55:9090/Cash/GetLoanContract?$queryString',
      data: {
        'Custodycd': Custodycd,
        'Acctno': Acctno,
        'From': From,
        'To': To,
      },
      options: Options(headers: headers),
    );
    if (res.statusCode == 200) {
      final rawData = res.data['data'];
      return rawData;
    } else {
      return [];
    }
  } catch (e) {
    return Future.error(e);
  }
}
