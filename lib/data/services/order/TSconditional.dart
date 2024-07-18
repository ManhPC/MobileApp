import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Dio _dio = Dio();

Future<Response> tsCon(
    String afAcctNo,
    String execType,
    int orderQtty,
    String rangePrice,
    String slidingPriceStep,
    String symbol,
    String toDate,
    String via) async {
  try {
    String token = HydratedBloc.storage.read('token');
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final Map<String, dynamic> data = {};

    // Kiểm tra và thêm các giá trị không rỗng vào data
    if (afAcctNo.isNotEmpty) data['afAcctNo'] = afAcctNo;
    data['orderQtty'] = orderQtty;
    if (execType.isNotEmpty) data['execType'] = execType;

    if (slidingPriceStep.isNotEmpty) {
      data['slidingPriceStep'] = slidingPriceStep;
    }
    if (rangePrice.isNotEmpty) data['rangePrice'] = rangePrice;
    if (symbol.isNotEmpty) data['symbol'] = symbol;
    if (toDate.isNotEmpty) data['toDate'] = toDate;
    if (via.isNotEmpty) data['via'] = via;

    final response = await _dio.post(
      'http://192.168.2.55:9090/Order/TrailingStopConditional',
      data: data,
      options: Options(headers: headers),
    );
    return response;
  } catch (e) {
    return Future.error(e);
  }
}
