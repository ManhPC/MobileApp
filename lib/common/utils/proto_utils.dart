class ProtoUtils {
  static int toInt(value) {
    return toNullableInt(value) ?? 0;
  }

  static int? toNullableInt(value) {
    if (value is num) return value.round();
    if (value is String) {
      if (value.isEmpty) return null;
      return int.tryParse(value);
    }
    return null;
  }

  static double? toDouble(value) {
    if (value is num) return value.toDouble();
    if (value is String) {
      if (value.isEmpty) return null;
      return double.tryParse(value);
    }
    return null;
  }
}
