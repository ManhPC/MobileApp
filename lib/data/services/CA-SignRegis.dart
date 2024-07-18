// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:nvs_trading/data/model/ca_sign_registration.dart';

Dio _dio = Dio();

Future<List<CASignRegistration>> CaSignRegistration(
    String pCustId, String token) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.get(
      'http://192.168.2.55:9090/api/CA-Sign/CA-Sign-Registration-View?pCustId=$pCustId',
      data: {
        'pCustId': pCustId,
      },
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      final List<dynamic> rawData = response.data['data'];
      List<CASignRegistration> resData =
          rawData.map((data) => CASignRegistration.fromJson(data)).toList();
      return resData;
    } else {
      print(response.statusCode);
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
}

Future<Response> addCaSignRegistration(
  String UserInfo,
  String custId,
  String description,
  String fromDate,
  String persionalPass,
  String persionalUserId,
  String status,
  String toDate,
  String token,
) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final res = await _dio.post(
      'http://192.168.2.55:9090/api/CA-Sign/CA-Sign-Registration-Add',
      data: {
        'UserInfo': UserInfo,
        'custId': custId,
        'description': description,
        'fromDate': fromDate,
        'persionalPass': persionalPass,
        'persionalUserId': persionalUserId,
        'status': status,
        'toDate': toDate,
      },
      options: Options(headers: headers),
    );
    return res;
  } catch (e) {
    print(e);
    return Future.error(e);
  }
}

Future<int?> deleteCaSignRegistration(int pAutoId, String token) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final res = await _dio.delete(
      'http://192.168.2.55:9090/api/CA-Sign/CA-Sign-Registration-Delete?pAutoId=$pAutoId',
      options: Options(headers: headers),
    );
    if (res.statusCode == 200) {
      return res.data['errorCode'];
    } else {
      return res.statusCode;
    }
  } catch (e) {
    print(e);
    return 0;
  }
}

Future<Response> updateCaSignRegistration(
  String UserInfo,
  int autoId,
  String custId,
  String description,
  String fromDate,
  String persionalPass,
  String persionalUserId,
  String status,
  String toDate,
  String token,
) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final res = await _dio.put(
      'http://192.168.2.55:9090/api/CA-Sign/CA-Sign-Registration-Edit',
      data: {
        'UserInfo': UserInfo,
        'autoId': autoId,
        'custId': custId,
        'description': description,
        'fromDate': fromDate,
        'persionalPass': persionalPass,
        'persionalUserId': persionalUserId,
        'status': status,
        'toDate': toDate,
      },
      options: Options(headers: headers),
    );
    return res;
  } catch (e) {
    print(e);
    return Future.error(e);
  }
}
