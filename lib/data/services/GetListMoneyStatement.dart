import 'dart:convert';
import 'package:dio/dio.dart';

Future<Map<String, dynamic>> getListMoneyStatement(
    String custodycd,
    String acctno,
    String startDate,
    String endDate,
    int from,
    int to,
    String token) async {
  try {
    List<String> data = [];

    data.add('Custodycd=$custodycd');
    data.add('Acctno=$acctno');

    if (startDate.isNotEmpty) {
      data.add('StartDate=$startDate');
    }
    if (endDate.isNotEmpty) {
      data.add('EndDate=$endDate');
    }

    data.add('from=$from');
    data.add('to=$to');

    final Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
    };

    String queryString = data.join('&');
    final response = await Dio().get(
      'http://192.168.2.55:9090/Cash/GetListMoneyStatement?$queryString',
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = response.data;
      // print(responseData);
      List<dynamic> dataList = responseData['data'];
      int begBalance = responseData['beG_BALANCE'] ?? 0;
      int endBalance = responseData['enD_BALANCE'] ?? 0;

      // print('Data List: $dataList');
      // print('Begin Balance: $begBalance');
      // print('End Balance: $endBalance');

      return {
        'data': dataList,
        'beG_BALANCE': begBalance,
        'enD_BALANCE': endBalance,
      };
    } else {
      print("Failed: ${response.statusCode}");
      return {};
    }
  } catch (e) {
    print("Error fetching data: $e");
    return {};
  }
}
