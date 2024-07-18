import 'package:nvs_trading/common/utils/extensions/string_extensions.dart';

import 'number_utils.dart';

// ignore: constant_identifier_names
const multiples_of_price = 1000;

String toFormattedStockPriceStr(String price) {
  return toFormattedNumber(int.parse(price), precision: 2);
}

String toFormattedStockPrice(num price) {
  return toFormattedNumber(price, precision: 2);
}

String toFormattedPrice(num price) {
  return toFormattedNumber(price, precision: 0);
}

String toFormattedPriceStatement(num price) {
  return toFormattedNumber(price / multiples_of_price, precision: 0);
}

String toFormattedOrderPrice(num? price, {bool isBasic = true}) {
  if (price == null) return '';
  return price != 0
      ? toFormattedNumber(price / multiples_of_price,
          precision: isBasic ? 2 : 1)
      : '';
}

String toFormattedStatementPrice(num? price) {
  if (price == null) return '';
  return price != 0
      ? toFormattedNumber(price / multiples_of_price, precision: 0)
      : '';
}

String toFormattedDealPrice(num price) {
  return price != 0
      ? toFormattedNumber(price / multiples_of_price, precision: 3)
      : '-';
}

int getPrice000(double? price) {
  if (price == null) return 0;
  return (price * multiples_of_price).round();
}

double convertPrice4Trade(dynamic price) {
  return (string2Double('$price') * multiples_of_price).roundToDouble();
}

double string2Double(String textValue, {double defaultValue = 0}) {
  try {
    return num.tryParse(textValue)?.toDouble() ?? defaultValue;
  } catch (ex) {
    return defaultValue;
  }
}

double? calculateStockValue(double matchPrice, int totalQuantity) {
  try {
    return (totalQuantity * matchPrice).floorToDouble();
  } catch (error) {
    return null;
  }
}

double calculateProfitContract(List<double>? contractInfo) {
  int validLength = 8;
  double profitContract;
  if (contractInfo == null || contractInfo.length != validLength) {
    return 0;
  }
  for (var i = 0; i < contractInfo.length; i++) {
    if (contractInfo[i].runtimeType != double) {
      return 0;
    }
  }

  profitContract = (((contractInfo[0] - contractInfo[1]) *
              (contractInfo[2] + contractInfo[3])) -
          ((contractInfo[0] - contractInfo[4]) *
              (contractInfo[5] + contractInfo[6]))) *
      contractInfo[7];

  return "$profitContract".isValidNumber
      ? !(profitContract == -0.0)
          ? double.tryParse("$profitContract") ?? 0
          : 0
      : 0;
}

double calculateProfitContractV2(
    List<double>? contractInfo, double? temporaryProfit,
    {String? tradeSessionCode}) {
  int validLength = 8;
  double profitContract;
  if (contractInfo == null || contractInfo.length != validLength) {
    return 0;
  }
  for (var i = 0; i < contractInfo.length; i++) {
    if (contractInfo[i].runtimeType != double) {
      return 0;
    }
  }
  if (contractInfo[0] != 0) {
    profitContract = ((contractInfo[0] - contractInfo[1]) *
                (contractInfo[2] + contractInfo[3]) -
            (contractInfo[0] - contractInfo[4]) *
                (contractInfo[5] + contractInfo[6])) *
        contractInfo[7];

    return "$profitContract".isValidNumber
        ? !(profitContract == -0.0)
            ? double.tryParse("$profitContract") ?? 0
            : 0
        : 0;
  }

  return "$temporaryProfit".isValidNumber
      ? double.tryParse("$temporaryProfit") ?? 0
      : 0;
}

double getProfit({
  double marketPrice = 0,
  double costPrice = 0,
  int quantity = 0,
  String? symbol,
  String? tradeSessionCode = "01",
  double? temporaryProfit = 0,
}) {
  double result;
  if (tradeSessionCode == "90" || tradeSessionCode == "96") {
    result = "$temporaryProfit".isValidNumber
        ? double.tryParse("$temporaryProfit") ?? 0
        : 0;
  } else {
    result = ((marketPrice * 1000) - costPrice) * quantity;
  }

  return !(result == -0.0)
      ? !(result.isNaN)
          ? result
          : 0
      : 0;
}

double getProfitPercentage({
  double marketPrice = 0,
  double costPrice = 0,
  int quantity = 0,
  String? symbol,
  String? tradeSessionCode = "01",
  double? temporaryProfit = 0,
}) {
  double result;
  if (tradeSessionCode == "90" || tradeSessionCode == "96") {
    result = "$temporaryProfit".isValidNumber
        ? (double.tryParse("$temporaryProfit") ?? 0) /
            (costPrice * quantity) *
            100
        : 0;
  } else {
    result = (((marketPrice * 1000) - costPrice) * quantity) /
        (costPrice * quantity) *
        100;
  }

  return !(result == -0.0)
      ? !(result.isNaN)
          ? result
          : 0
      : 0;
}

double getMarketValue({
  double marketPrice = 0,
  String? tradeSessionCode = "01",
  double? currPrice = 0,
}) {
  double result;
  if (tradeSessionCode == "90" || tradeSessionCode == "96") {
    result = "$currPrice".isValidNumber
        ? (double.tryParse("$currPrice") ?? 0) / 1000
        : 0;
  } else {
    result = marketPrice;
  }

  return !(result == -0.0)
      ? !(result.isNaN)
          ? result
          : 0
      : 0;
}

double getTotalMarketValue({
  double marketPrice = 0,
  double totalQtty = 0,
  String? tradeSessionCode = "01",
  double? currPrice = 0,
}) {
  double result;
  if (tradeSessionCode == "90" || tradeSessionCode == "96") {
    result = "$currPrice".isValidNumber
        ? (double.tryParse("$currPrice") ?? 0) / 1000 * totalQtty
        : 0;
  } else {
    result = (marketPrice * totalQtty);
  }

  return !(result == -0.0)
      ? !(result.isNaN)
          ? result
          : 0
      : 0;
}
