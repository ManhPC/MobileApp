// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/model/group_stock.dart';

Dio _dio = Dio();
String token = HydratedBloc.storage.read('token');

Future<List<GroupStock>> listGroupStock() async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.get(
      'http://192.168.2.55:9090/CategoryStock/ListGroupStock',
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      final List<dynamic> rawData = response.data['data'];
      final List<GroupStock> jsonData =
          rawData.map((e) => GroupStock.fromJson(e)).toList();
      return jsonData;
    } else {
      print(response.statusCode);
      return [];
    }
  } catch (e) {
    return Future.error(e);
  }
}

Future<int> editGroupStock(String groupId, String groupName) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.post(
      'http://192.168.2.55:9090/CategoryStock/EditGroupStock',
      data: {
        'groupId': groupId,
        'groupName': groupName,
      },
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      final rawData = response.data['code'];
      return rawData;
    } else {
      print(response.statusCode);
      return -1;
    }
  } catch (e) {
    return Future.error(e);
  }
}

Future<int> deleteGroupStock(String groupId) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.post(
      'http://192.168.2.55:9090/CategoryStock/DeleteGroupStock',
      data: {
        'groupId': groupId,
      },
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      final rawData = response.data['code'];
      return rawData;
    } else {
      print(response.statusCode);
      return -1;
    }
  } catch (e) {
    return Future.error(e);
  }
}

Future<int> createGroupStock(String groupName) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
    final response = await _dio.post(
        'http://192.168.2.55:9090/CategoryStock/CreateGroupStock',
        data: {
          'groupName': groupName,
        },
        options: Options(headers: headers));
    if (response.statusCode == 200) {
      final rawData = response.data['code'];
      return rawData;
    } else {
      print(response.statusCode);
      return -1;
    }
  } catch (e) {
    return Future.error(e);
  }
}

Future<int> addNewSymbol(String groupId, String symbol) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': "Bearer $token"};
    final response = await _dio.post(
      'http://192.168.2.55:9090/CategoryStock/AddNewSymbol',
      data: {
        'groupId': groupId,
        'symbol': symbol,
      },
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      final rawData = response.data['code'];
      return rawData;
    } else {
      print("Loi add Symbol");
      return -1;
    }
  } catch (e) {
    return Future.error(e);
  }
}

Future<int> removeSymbol(String groupId, String symbol) async {
  try {
    final Map<String, dynamic> headers = {'Authorization': "Bearer $token"};
    final response = await _dio.post(
      'http://192.168.2.55:9090/CategoryStock/RemoveSymbol',
      data: {
        'groupId': groupId,
        'symbol': symbol,
      },
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      final rawData = response.data['code'];
      return rawData;
    } else {
      print("Loi remove Symbol");
      return -1;
    }
  } catch (e) {
    return Future.error(e);
  }
}
