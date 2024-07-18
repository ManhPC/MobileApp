import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// ignore_for_file: non_constant_identifier_names

Dio _dio = Dio();

Future<List<dynamic>> SecuritiesStatement(
    String custodycd,
    String acctno,
    String StartDate,
    String EndDate,
    String symbol,
    String TransactionType,
    int from,
    int to,
    String token) async {
  try {
    List<String> data = [];

    data.add('Custodycd=$custodycd');

    data.add('Acctno=$acctno');

    if (StartDate.isNotEmpty) {
      data.add('StartDate=${StartDate}');
    }
    if (EndDate.isNotEmpty) {
      data.add('EndDate=$EndDate');
    }
    if (symbol.isNotEmpty && symbol != "null") {
      data.add('symbol=$symbol');
    }
    if (TransactionType.isNotEmpty) {
      data.add('TransactionType=$TransactionType');
    }

    data.add('from=$from');

    data.add('to=$to');
    final Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
    };
    String queryString = data.join('&');
    final response = await _dio.get(
      'http://192.168.2.55:9090/Assets/SecuritiesStatement?$queryString',
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      List<dynamic> rawData = response.data['data'];

      // HydratedBloc.storage.write('data', response.data['data']);

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
