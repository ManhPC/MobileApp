import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// ignore_for_file: non_constant_identifier_names

Dio _dio = Dio();

Future<List<dynamic>> GetGainOrLost(String acctno, String StartDate,
    String EndDate, String symbol, int from, int to) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    List<String> data = [];
    data.add('Acctno=$acctno');

    if (StartDate.isNotEmpty) {
      data.add('FromDate=$StartDate');
    }
    if (EndDate.isNotEmpty) {
      data.add('ToDate=$EndDate');
    }
    if (symbol.isNotEmpty && symbol != "null") {
      data.add('symbol=$symbol');
    }

    data.add('from=$from');

    data.add('to=$to');

    String queryString = data.join('&');
    final response = await _dio.get(
      'http://192.168.2.55:9090/Assets/GetGainOrLost?$queryString',
      data: {
        'AccTno': acctno,
        'FromDate': StartDate,
        'ToDate': EndDate,
        'Symbol': symbol,
        'from': from,
        'to': to,
      },
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      List<dynamic> rawData = response.data['data'];
      return rawData;
    } else {
      print("Failed: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print("Error fetching data: $e");
    return [];
  }
}
