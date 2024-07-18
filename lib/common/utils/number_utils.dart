import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:nvs_trading/common/utils/price_utils.dart';

String toThousandCharacterFormat(num? number,
    {int precision = 0, decimalSeparator = '.'}) {
  if (number == null || number.isNaN || number.isInfinite) return '-';
  var formatString = decimalSeparator == '.' ? ',##0' : '.##0';
  if (precision > 0) {
    formatString += decimalSeparator;
    for (var i = 0; i < precision; i++) {
      formatString += '0';
    }
  }
  return NumberFormat(formatString, 'en_US').format(number);
}

String formatValueNumber(String value, {int precision = 1}) {
  if (value.startsWith('-')) {
    final positiveFormatValue = _formatPositiveNumber(
        value.substring(1, value.length),
        precision: precision);
    return '-$positiveFormatValue';
  }
  return _formatPositiveNumber(value, precision: precision);
}

String _formatPositiveNumber(String value, {int precision = 1}) {
  final chars = value.replaceAll(',', '').split('.');

  final charsBeforeDot = (chars[0]).split('');
  var result = '';
  final charsBeforeDotLength = charsBeforeDot.length;
  for (var i = 0; i < charsBeforeDotLength; i++) {
    result += charsBeforeDot[i];
    final position = charsBeforeDotLength - i - 1;
    if (position % 3 == 0 && position != 0) result += ',';
  }
  if (precision > 0) {
    result += '.';
    var additionalLength = precision;
    if (chars.length > 1) {
      final charsAfterDot = chars[1].split('');
      var maxIndex = precision;
      if (precision > charsAfterDot.length) {
        maxIndex = charsAfterDot.length;
        additionalLength = precision - charsAfterDot.length;
      } else {
        additionalLength = 0;
      }

      if (charsAfterDot.isNotEmpty) {
        for (var i = 0; i < maxIndex; i++) {
          result += charsAfterDot[i];
        }
      }
    }

    for (var i = 0; i < additionalLength; i++) {
      result += '0';
    }
  }
  return result;
}

String? removePerThousandCharacter(String? value,
    {String perThousandCharacter = ','}) {
  if (value != null && value.isEmpty) return '';
  return value?.replaceAll(perThousandCharacter, '');
}

double? getValueFromTextFieldFormatted(
    TextEditingController textEditingController,
    {double defaultValue = 0.0,
    perThousandCharacter = ','}) {
  final currentValue = removePerThousandCharacter(textEditingController.text);
  return string2Double(currentValue, defaultValue: defaultValue);
}

double? getValueFromTextField(TextEditingController textEditingController,
    {double defaultValue = 0.0}) {
  final currentValue = textEditingController.text;

  return string2Double(currentValue, defaultValue: defaultValue);
}

double string2Double(String? textValue, {double defaultValue = 0.0}) {
  try {
    return num.tryParse(textValue ?? '')?.toDouble() ?? defaultValue;
  } catch (ex) {
    return defaultValue;
  }
}

int getNumbFromThousand(String str) =>
    string2Int(removePerThousandCharacter(str));

int string2Int(String? textValue, {int defaultValue = 0}) {
  try {
    return int.tryParse(textValue ?? '') ?? defaultValue;
  } catch (ex) {
    return defaultValue;
  }
}

String toFormattedNumber(num? number,
    {int precision = 2, decimalSeparator = '.'}) {
  var formatString = decimalSeparator == '.' ? ',##0' : '.##0';
  if (precision > 0) {
    formatString += decimalSeparator;
    for (var i = 0; i < precision; i++) {
      formatString += '0';
    }
  }
  return NumberFormat(formatString, 'en_US').format(number ?? 0);
}

String toFormattedNumberList(String? number) {
  if (number!.isNotEmpty && number != "0" && number != "null") {
    double t = (double.parse(number.replaceAll(RegExp(r'[^\w\s]+'), '')));
    return toFormattedOrderPrice(t);
  } else {
    return "0";
  }
}

String toFormattedNumber1(num? number,
    {int precision = 0, decimalSeparator = '.'}) {
  var formatString = decimalSeparator == '.' ? ',##0' : '.##0';
  if (precision > 0) {
    formatString += decimalSeparator;
    for (var i = 0; i < precision; i++) {
      formatString += '0';
    }
  }
  return NumberFormat(formatString, 'en_US').format(number ?? 0);
}

String toFormattedStockQuantity(num? quantity) {
  return quantity != 0
      ? NumberFormat('#,###,###,##', 'en_US').format(quantity ?? 0)
      : '-';
}

String toFormattedStockQuantityShow(num? quantity) {
  if (quantity == null) return '-';
  return quantity != 0
      ? NumberFormat('#,###,###,##', 'en_US').format(quantity / 10)
      : '-';
}

String toFormattedContractQuantity(num? quantity) {
  if (quantity == null) return '-';
  return quantity != 0
      ? NumberFormat('#,###,###,##', 'en_US').format(quantity)
      : '-';
}

String toFormattedQuantity(num? quantity) {
  if (quantity == null) return '-';
  return quantity != 0
      ? NumberFormat('#,###,###,###', 'en_US').format(quantity)
      : '-';
}

String toFormattedQuantityShow(num? quantity) {
  if (quantity == null) return '-';
  return quantity != 0
      ? NumberFormat('#,###,###,###', 'en_US').format(quantity / 10)
      : '-';
}

String rateToPercent(double? rateValue,
    {int precision = 0,
    bool showZeroAfterDot = true,
    bool showPositive = false,
    String defaultText = '-'}) {
  if (rateValue != null) {
    final prefix = showPositive && rateValue > 0 ? '+' : '';
    const defaultFormat = '#,###,###,##0';
    final afterDotCharacter = showZeroAfterDot ? '0' : '#';

    final percentValue = rateValue * 100;
    final format = precision > 0
        ? '$defaultFormat.${afterDotCharacter * precision}'
        : defaultFormat;
    return '$prefix${NumberFormat(format, 'en_US').format(percentValue)}%';
  }
  return defaultText;
}

String rateToPercentAssets(double? rateValue,
    {int precision = 0,
    bool showZeroAfterDot = true,
    bool showPositive = false,
    String defaultText = '-'}) {
  if (rateValue != null) {
    final prefix = showPositive && rateValue > 0 ? '+' : '';
    const defaultFormat = '#,###,###,##0';
    final afterDotCharacter = showZeroAfterDot ? '0' : '#';

    final percentValue = rateValue * 100;
    final format = precision > 0
        ? '$defaultFormat.${afterDotCharacter * precision}'
        : defaultFormat;
    return '$prefix${NumberFormat(format, 'en_US').format(percentValue)}%';
  }
  return defaultText;
}

String formatPhoneNumber(String phoneNumber) {
  List<String> num = phoneNumber.split("");
  String fNum = num[0] + num[1] + num[2];
  String sNum = num[7] + num[8] + num[9];
  return '$fNum****$sNum';
}
