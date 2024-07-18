import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// ignore_for_file: non_constant_identifier_names

Dio _dio = Dio();

Future<List<dynamic>> FilterData(String custodycd, String acctno, List status,
    String OrderType, String symbol, int from, int to, String token) async {
  try {
    List<String> data = [];

    data.add('Custodycd=$custodycd');

    data.add('Acctno=$acctno');

    if (status.join(',').isNotEmpty) {
      data.add('status=${status.join(',')}');
    }
    if (OrderType.isNotEmpty) {
      data.add('OrderType=$OrderType');
    }
    if (symbol.isNotEmpty && symbol != "null") {
      data.add('symbol=$symbol');
    }
    data.add('from=$from');

    data.add('to=$to');
    final Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
    };
    String queryString = data.join('&');
    final response = await _dio.get(
      'http://192.168.2.55:9090/Order/GetListOrderInDay?$queryString',
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      List<dynamic> rawData = response.data['data'];
      HydratedBloc.storage.write('totalRecords', response.data['totalRecords']);
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

Future<List<dynamic>> editOrder(String orderId, String orderType, String price,
    String quantity, String quantityNew) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.put(
      'http://192.168.2.55:9090/Order/EditOrder',
      data: {
        'orderId': orderId,
        'orderType': orderType,
        'price': price,
        'quantity': quantity,
        'quantityNew': quantityNew,
      },
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      final List<dynamic> rawData = response.data['listResult'];
      return rawData;
    } else {
      print(response.statusCode);
      return [];
    }
  } catch (e) {
    return Future.error(e);
  }
}

Future<Response> Cancelorders(String orderId) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
    };
    final response = await _dio.put(
      'http://192.168.2.55:9090/Order/CancelOrder',
      data: {"orderid": orderId},
      options: Options(headers: headers),
    );
    return response;
  } catch (e) {
    print("Error: $e");
    rethrow;
  }
}
