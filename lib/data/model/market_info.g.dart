// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketInfo _$MarketInfoFromJson(Map<String, dynamic> json) => MarketInfo(
      bidPrice3Color: BaseModel.intFromJsonNullable(json['color4']),
      bidPrice2Color: BaseModel.intFromJsonNullable(json['color6']),
      bidPrice1Color: BaseModel.intFromJsonNullable(json['color8']),
      offerPrice3Color: BaseModel.intFromJsonNullable(json['color10']),
      offerPrice2Color: BaseModel.intFromJsonNullable(json['color12']),
      offerPrice1Color: BaseModel.intFromJsonNullable(json['color14']),
      matchPriceColor: BaseModel.intFromJsonNullable(json['color16']),
      changePriceColor: BaseModel.intFromJsonNullable(json['color17']),
      pctChangePriceColor: BaseModel.intFromJsonNullable(json['color18']),
      matchQttyColor: BaseModel.intFromJsonNullable(json['color19']),
      exerciseRatioColor: BaseModel.intFromJsonNullable(json['color36']),
      changeTotalTradedQtty: BaseModel.intFromJsonNullable(json['53']),
      avgTotalTradedQtty10Days: json['54'] as String?,
      symbol: json['symbol'] as String?,
      ceilPrice: BaseModel.doubleFromJsonNullable(json['1']),
      floorPrice: BaseModel.doubleFromJsonNullable(json['2']),
      refPrice: BaseModel.doubleFromJsonNullable(json['3']),
      avgPrice: BaseModel.doubleFromJsonNullable(json['23']),
      basis: json['60'] as String?,
      bidPrice1: json['8'] as String?,
      bidPrice2: json['6'] as String?,
      bidPrice3: json['4'] as String?,
      bidQtty1: BaseModel.intFromJsonNullable(json['9']),
      bidQtty2: BaseModel.intFromJsonNullable(json['7']),
      bidQtty3: BaseModel.intFromJsonNullable(json['5']),
      buyForeignQtty: BaseModel.intFromJsonNullable(json['25']),
      buyForeignValue: BaseModel.intFromJsonNullable(json['26']),
      changePrice: BaseModel.doubleFromJsonNullable(json['17']),
      closePrice: BaseModel.doubleFromJsonNullable(json['31']),
      exercisePrice: BaseModel.doubleFromJsonNullable(json['35']),
      exerciseRatio: BaseModel.doubleFromJsonNullable(json['36']),
      highestPrice: BaseModel.doubleFromJsonNullable(json['22']),
      lowestPrice: BaseModel.doubleFromJsonNullable(json['24']),
      marketCode: json['34'] as String?,
      marketName: json['47'] as String?,
      marketNameEn: json['48'] as String?,
      matchPrice: BaseModel.doubleFromJsonNullable(json['16']),
      matchQtty: BaseModel.intFromJsonNullable(json['19']),
      offerPrice1: json['14'] as String?,
      offerPrice2: json['12'] as String?,
      offerPrice3: json['10'] as String?,
      offerQtty1: BaseModel.intFromJsonNullable(json['15']),
      offerQtty2: BaseModel.intFromJsonNullable(json['13']),
      offerQtty3: BaseModel.intFromJsonNullable(json['11']),
      openInterest: BaseModel.doubleFromJsonNullable(json['32']),
      openInterestChange: BaseModel.doubleFromJsonNullable(json['33']),
      openPrice: BaseModel.doubleFromJsonNullable(json['30']),
      pctChangePrice: BaseModel.doubleFromJsonNullable(json['18']),
      referenceStatus: json['65'] as String?,
      remainForeignQtty: BaseModel.intFromJsonNullable(json['29']),
      securityTradingStatus: BaseModel.intFromJsonNullable(json['44']),
      securityType: json['45'] as String?,
      sellForeignQtty: BaseModel.intFromJsonNullable(json['27']),
      sellForeignValue: BaseModel.intFromJsonNullable(json['28']),
      subForeignQtty: BaseModel.intFromJsonNullable(json['51']),
      subForeignValue: BaseModel.intFromJsonNullable(json['52']),
      symbolName: json['59'] as String?,
      totalBidQtty: BaseModel.intFromJsonNullable(json['49']),
      totalBuyQtty: BaseModel.intFromJsonNullable(json['55']),
      totalBuyValue: (json['totalBuyValue'] as num?)?.toInt(),
      totalOfferQtty: BaseModel.intFromJsonNullable(json['50']),
      totalSellQtty: BaseModel.intFromJsonNullable(json['56']),
      totalSellValue: BaseModel.intFromJsonNullable(json['58']),
      totalTradedQtty: BaseModel.intFromJsonNullable(json['20']),
      totalTradedQttyNM: BaseModel.intFromJsonNullable(json['61']),
      totalTradedQttyPT: BaseModel.intFromJsonNullable(json['63']),
      totalTradedValue: BaseModel.intFromJsonNullable(json['21']),
      totalTradedValueNM: BaseModel.intFromJsonNullable(json['62']),
      totalTradedValuePT: BaseModel.intFromJsonNullable(json['64']),
      tradeSessionCode: json['46'] as String?,
      underlying: json['37'] as String?,
      underlyingPrice: BaseModel.doubleFromJsonNullable(json['42']),
    );

Map<String, dynamic> _$MarketInfoToJson(MarketInfo instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      '1': instance.ceilPrice,
      '2': instance.floorPrice,
      '3': instance.refPrice,
      '4': instance.bidPrice3,
      'color4': instance.bidPrice3Color,
      '5': instance.bidQtty3,
      '6': instance.bidPrice2,
      'color6': instance.bidPrice2Color,
      '7': instance.bidQtty2,
      '8': instance.bidPrice1,
      'color8': instance.bidPrice1Color,
      '9': instance.bidQtty1,
      '10': instance.offerPrice3,
      'color10': instance.offerPrice3Color,
      '11': instance.offerQtty3,
      '12': instance.offerPrice2,
      'color12': instance.offerPrice2Color,
      '13': instance.offerQtty2,
      '14': instance.offerPrice1,
      'color14': instance.offerPrice1Color,
      '15': instance.offerQtty1,
      'color16': instance.matchPriceColor,
      '16': instance.matchPrice,
      '17': instance.changePrice,
      'color17': instance.changePriceColor,
      '18': instance.pctChangePrice,
      'color18': instance.pctChangePriceColor,
      '19': instance.matchQtty,
      'color19': instance.matchQttyColor,
      '20': instance.totalTradedQtty,
      '21': instance.totalTradedValue,
      '22': instance.highestPrice,
      '23': instance.avgPrice,
      '24': instance.lowestPrice,
      '25': instance.buyForeignQtty,
      '26': instance.buyForeignValue,
      '27': instance.sellForeignQtty,
      '28': instance.sellForeignValue,
      '29': instance.remainForeignQtty,
      '30': instance.openPrice,
      '31': instance.closePrice,
      '32': instance.openInterest,
      '33': instance.openInterestChange,
      '34': instance.marketCode,
      '35': instance.exercisePrice,
      'color36': instance.exerciseRatioColor,
      '36': instance.exerciseRatio,
      '37': instance.underlying,
      '45': instance.securityType,
      '46': instance.tradeSessionCode,
      '42': instance.underlyingPrice,
      '44': instance.securityTradingStatus,
      '47': instance.marketName,
      '48': instance.marketNameEn,
      '49': instance.totalBidQtty,
      '50': instance.totalOfferQtty,
      '51': instance.subForeignQtty,
      'totalBuyValue': instance.totalBuyValue,
      '52': instance.subForeignValue,
      '53': instance.changeTotalTradedQtty,
      '54': instance.avgTotalTradedQtty10Days,
      '55': instance.totalBuyQtty,
      '56': instance.totalSellQtty,
      '58': instance.totalSellValue,
      '59': instance.symbolName,
      '60': instance.basis,
      '61': instance.totalTradedQttyNM,
      '62': instance.totalTradedValueNM,
      '63': instance.totalTradedQttyPT,
      '64': instance.totalTradedValuePT,
      '65': instance.referenceStatus,
    };
