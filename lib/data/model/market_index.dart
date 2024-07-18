import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:nvs_trading/data/model/base_model.dart';

part 'market_index.g.dart';

@CopyWith()
@JsonSerializable()
class MarketIndex extends BaseModel {
  @JsonKey(name: 'symbol')
  final String? symbol;
  @JsonKey(name: '1')
  final String? indexName;
  @JsonKey(name: '2')
  final String? typeIndex;
  @JsonKey(name: '3')
  final String? priorIndex;
  @JsonKey(name: '4')
  final String? currentIndex;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: 'color4')
  final int? currentIndexColor;
  @JsonKey(name: '5')
  final String? changeIndex;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: 'color5')
  final int? changeIndexColor;
  @JsonKey(name: '6')
  final String? pctChangeIndex;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: 'color6')
  final int? pctChangeIndexColor;
  @JsonKey(name: '11')
  final String? totalTradedValue;

  MarketIndex({
    this.symbol,
    this.indexName,
    this.typeIndex,
    this.priorIndex,
    this.currentIndex,
    this.changeIndex,
    this.pctChangeIndex,
    this.currentIndexColor,
    this.changeIndexColor,
    this.pctChangeIndexColor,
    this.totalTradedValue,
  });

  factory MarketIndex.fromJson(Map<String, dynamic> json) =>
      _$MarketIndexFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MarketIndexToJson(this);
}

enum ReferenceStatus {
  normal,
}
