import 'package:json_annotation/json_annotation.dart';

part 'message_market.g.dart';

@JsonSerializable()
class MessageMarket {
  final int msgType;
  final String message;
  MessageMarket(
    this.msgType,
    this.message,
  );
  factory MessageMarket.fromJson(Map<String, dynamic> json) =>
      _$MessageMarketFromJson(json);
  Map<String, dynamic> toJson() => _$MessageMarketToJson(this);
}
