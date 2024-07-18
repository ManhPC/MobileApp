import 'dart:convert';

import 'package:nvs_trading/common/utils/proto_utils.dart';

abstract class BaseModel {
  static String valueToJson(value) {
    try {
      return jsonEncode(value);
    } catch (e) {
      return value?.toString() ?? "Có lỗi xảy ra";
    }
  }

  Map<String, dynamic> toJson();

  @override
  String toString() {
    final json = toJson();
    return jsonEncode(json);
  }

  static int? intFromJsonNullable(value) {
    return ProtoUtils.toNullableInt(value);
  }

  static double? doubleFromJsonNullable(value) {
    return ProtoUtils.toDouble(value);
  }
}
