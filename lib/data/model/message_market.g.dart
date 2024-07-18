// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_market.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageMarket _$MessageMarketFromJson(Map<String, dynamic> json) =>
    MessageMarket(
      (json['msgType'] as num).toInt(),
      json['message'] as String,
    );

Map<String, dynamic> _$MessageMarketToJson(MessageMarket instance) =>
    <String, dynamic>{
      'msgType': instance.msgType,
      'message': instance.message,
    };
