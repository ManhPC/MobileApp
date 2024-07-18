// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_index.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketIndex _$MarketIndexFromJson(Map<String, dynamic> json) => MarketIndex(
      symbol: json['symbol'] as String?,
      indexName: json['1'] as String?,
      typeIndex: json['2'] as String?,
      priorIndex: json['3'] as String?,
      currentIndex: json['4'] as String?,
      changeIndex: json['5'] as String?,
      pctChangeIndex: json['6'] as String?,
      currentIndexColor: BaseModel.intFromJsonNullable(json['color4']),
      changeIndexColor: BaseModel.intFromJsonNullable(json['color5']),
      pctChangeIndexColor: BaseModel.intFromJsonNullable(json['color6']),
      totalTradedValue: json['11'] as String?,
    );

Map<String, dynamic> _$MarketIndexToJson(MarketIndex instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      '1': instance.indexName,
      '2': instance.typeIndex,
      '3': instance.priorIndex,
      '4': instance.currentIndex,
      'color4': instance.currentIndexColor,
      '5': instance.changeIndex,
      'color5': instance.changeIndexColor,
      '6': instance.pctChangeIndex,
      'color6': instance.pctChangeIndexColor,
      '11': instance.totalTradedValue,
    };
