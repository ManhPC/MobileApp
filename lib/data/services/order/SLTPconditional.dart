import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<Response> SLTPCon(
  String afAcctNo,
  int orderQtty,
  String price,
  String priceCutLoss,
  String priceProfit,
  String rangePrice,
  String symbol,
  String toDate,
  String via,
) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final Map<String, dynamic> data = {};

    // Kiểm tra và thêm các giá trị không rỗng vào data
    if (afAcctNo.isNotEmpty) data['afAcctNo'] = afAcctNo;
    data['orderQtty'] = orderQtty;
    if (price.isNotEmpty) data['price'] = price;
    if (priceCutLoss.isNotEmpty) data['priceCutLoss'] = priceCutLoss;
    if (priceProfit.isNotEmpty) data['priceProfit'] = priceProfit;
    if (rangePrice.isNotEmpty) data['rangePrice'] = rangePrice;
    if (symbol.isNotEmpty) data['symbol'] = symbol;
    if (toDate.isNotEmpty) data['toDate'] = toDate;
    if (via.isNotEmpty) data['via'] = via;

    final response = await _dio.post(
      'http://192.168.2.55:9090/Order/SLTPConditional',
      data: data,
      options: Options(headers: headers),
    );
    return response;
  } catch (e) {
    return Future.error(e);
  }
}
