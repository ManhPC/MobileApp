import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:nvs_trading/data/model/base_model.dart';

part 'market_info.g.dart';

@CopyWith()
@JsonSerializable()
class MarketInfo {
  @JsonKey(name: 'symbol')
  final String? symbol;
  @JsonKey(fromJson: BaseModel.doubleFromJsonNullable, name: '1')
  final double? ceilPrice;
  @JsonKey(fromJson: BaseModel.doubleFromJsonNullable, name: '2')
  final double? floorPrice;
  @JsonKey(fromJson: BaseModel.doubleFromJsonNullable, name: '3')
  final double? refPrice;
  @JsonKey(name: '4')
  final String? bidPrice3;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: 'color4')
  final int? bidPrice3Color;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '5')
  final int? bidQtty3;
  @JsonKey(name: '6')
  final String? bidPrice2;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: 'color6')
  final int? bidPrice2Color;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '7')
  final int? bidQtty2;
  @JsonKey(name: '8')
  final String? bidPrice1;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: 'color8')
  final int? bidPrice1Color;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '9')
  final int? bidQtty1;
  @JsonKey(name: '10')
  final String? offerPrice3;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: 'color10')
  final int? offerPrice3Color;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '11')
  final int? offerQtty3;
  @JsonKey(name: '12')
  final String? offerPrice2;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: 'color12')
  final int? offerPrice2Color;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '13')
  final int? offerQtty2;
  @JsonKey(name: '14')
  final String? offerPrice1;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: 'color14')
  final int? offerPrice1Color;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '15')
  final int? offerQtty1;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: 'color16')
  final int? matchPriceColor;
  @JsonKey(fromJson: BaseModel.doubleFromJsonNullable, name: '16')
  final double? matchPrice;
  @JsonKey(fromJson: BaseModel.doubleFromJsonNullable, name: '17')
  final double? changePrice;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: 'color17')
  final int? changePriceColor;
  @JsonKey(fromJson: BaseModel.doubleFromJsonNullable, name: '18')
  final double? pctChangePrice;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: 'color18')
  final int? pctChangePriceColor;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '19')
  final int? matchQtty;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: 'color19')
  final int? matchQttyColor;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '20')
  final int? totalTradedQtty;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '21')
  final int? totalTradedValue;
  @JsonKey(fromJson: BaseModel.doubleFromJsonNullable, name: '22')
  final double? highestPrice;
  @JsonKey(fromJson: BaseModel.doubleFromJsonNullable, name: '23')
  final double? avgPrice;
  @JsonKey(fromJson: BaseModel.doubleFromJsonNullable, name: '24')
  final double? lowestPrice;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '25')
  final int? buyForeignQtty;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '26')
  final int? buyForeignValue;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '27')
  final int? sellForeignQtty;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '28')
  final int? sellForeignValue;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '29')
  final int? remainForeignQtty;
  @JsonKey(fromJson: BaseModel.doubleFromJsonNullable, name: '30')
  final double? openPrice;
  @JsonKey(fromJson: BaseModel.doubleFromJsonNullable, name: '31')
  final double? closePrice;
  @JsonKey(fromJson: BaseModel.doubleFromJsonNullable, name: '32')
  final double? openInterest;
  @JsonKey(fromJson: BaseModel.doubleFromJsonNullable, name: '33')
  final double? openInterestChange;
  @JsonKey(name: '34')
  final String? marketCode;
  @JsonKey(fromJson: BaseModel.doubleFromJsonNullable, name: '35')
  final double? exercisePrice;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: 'color36')
  final int? exerciseRatioColor;
  @JsonKey(fromJson: BaseModel.doubleFromJsonNullable, name: '36')
  final double? exerciseRatio;
  @JsonKey(name: '37')
  final String? underlying;
  // @JsonKey(name: '39')
  // final String? exercisePrice;
  @JsonKey(name: '45')
  final String? securityType;
  @JsonKey(name: '46')
  final String? tradeSessionCode;
  @JsonKey(fromJson: BaseModel.doubleFromJsonNullable, name: '42')
  final double? underlyingPrice;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '44')
  final int? securityTradingStatus;
  @JsonKey(name: '47')
  final String? marketName;
  @JsonKey(name: '48')
  final String? marketNameEn;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '49')
  final int? totalBidQtty;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '50')
  final int? totalOfferQtty;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '51')
  final int? subForeignQtty;
  final int? totalBuyValue;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '52')
  final int? subForeignValue;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '53')
  final int? changeTotalTradedQtty;
  @JsonKey(name: '54')
  final String? avgTotalTradedQtty10Days;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '55')
  final int? totalBuyQtty;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '56')
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '57')
  final int? totalSellQtty;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '58')
  final int? totalSellValue;
  @JsonKey(name: '59')
  final String? symbolName;
  @JsonKey(name: '60')
  final String? basis;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '61')
  final int? totalTradedQttyNM;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '62')
  final int? totalTradedValueNM;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: "63")
  final int? totalTradedQttyPT;
  @JsonKey(fromJson: BaseModel.intFromJsonNullable, name: '64')
  final int? totalTradedValuePT;
  @JsonKey(name: '65')
  final String? referenceStatus;

  MarketInfo({
    this.bidPrice3Color,
    this.bidPrice2Color,
    this.bidPrice1Color,
    this.offerPrice3Color,
    this.offerPrice2Color,
    this.offerPrice1Color,
    this.matchPriceColor,
    this.changePriceColor,
    this.pctChangePriceColor,
    this.matchQttyColor,
    this.exerciseRatioColor,
    this.changeTotalTradedQtty,
    this.avgTotalTradedQtty10Days,
    this.symbol,
    this.ceilPrice,
    this.floorPrice,
    this.refPrice,
    this.avgPrice,
    this.basis,
    this.bidPrice1,
    this.bidPrice2,
    this.bidPrice3,
    this.bidQtty1,
    this.bidQtty2,
    this.bidQtty3,
    this.buyForeignQtty,
    this.buyForeignValue,
    this.changePrice,
    this.closePrice,
    this.exercisePrice,
    this.exerciseRatio,
    this.highestPrice,
    this.lowestPrice,
    this.marketCode,
    this.marketName,
    this.marketNameEn,
    this.matchPrice,
    this.matchQtty,
    this.offerPrice1,
    this.offerPrice2,
    this.offerPrice3,
    this.offerQtty1,
    this.offerQtty2,
    this.offerQtty3,
    this.openInterest,
    this.openInterestChange,
    this.openPrice,
    this.pctChangePrice,
    this.referenceStatus,
    this.remainForeignQtty,
    this.securityTradingStatus,
    this.securityType,
    this.sellForeignQtty,
    this.sellForeignValue,
    this.subForeignQtty,
    this.subForeignValue,
    this.symbolName,
    this.totalBidQtty,
    this.totalBuyQtty,
    this.totalBuyValue,
    this.totalOfferQtty,
    this.totalSellQtty,
    this.totalSellValue,
    this.totalTradedQtty,
    this.totalTradedQttyNM,
    this.totalTradedQttyPT,
    this.totalTradedValue,
    this.totalTradedValueNM,
    this.totalTradedValuePT,
    this.tradeSessionCode,
    this.underlying,
    this.underlyingPrice,
  });

  String? get sessionName => traddingSessionCodeName[tradeSessionCode];

  factory MarketInfo.fromJson(Map<String, dynamic> json) =>
      _$MarketInfoFromJson(json);
  Map<String, dynamic> toJson() => _$MarketInfoToJson(this);
}

enum ReferenceStatus {
  normal,
}

const Map<String, String> traddingSessionCodeName = {
  '01': 'Mở cửa',
  '03': 'Tạm ngưng',
  '10': 'ATO',
  '30': 'Liên tục',
  '40': 'ATC',
  '60': 'Phiên thoả thuận',
  '61': 'Thỏa thuận',
  '90': 'Đóng cửa',
  '96': 'Đóng cửa',
};

const Map<String, String> securityTradingStatus = {
  '0': ' Bình thường',
  '1': ' Không giao dịch',
  '2': ' Nhưng giao dịch',
  '6': ' Hủy niêm yết',
  '7': ' Niêm yết mới',
  '8': ' Sắp hủy niêm yết',
  '10': ' Tạm ngừng giao dịch',
  '25': ' Giao dịch đặc biệt',
};
const Map<String, String> marketCode = {
  'STX': 'HNX',
  'UPX': 'UpCOM',
  'STO': 'HoSE',
  'HCX': 'Bond',
  'DVX': 'Phái sinh',
};
