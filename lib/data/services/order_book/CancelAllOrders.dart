import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<Response> Cancelallorders(List orderId, String acctno) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
    };
    final response = await _dio.put(
      'http://192.168.2.55:9090/Order/CancelAllOrders',
      data: {"orderid": orderId.join('|'), "acctno": acctno},
      options: Options(headers: headers),
    );
    return response;
  } catch (e) {
    print("Error: $e");
    rethrow;
  }
}
