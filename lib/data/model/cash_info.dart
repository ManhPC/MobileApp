import 'package:json_annotation/json_annotation.dart';

part 'cash_info.g.dart';

@JsonSerializable()
class CashInfoModel {
  int? balance;
  String? afacctno;
  int? t0;
  int? t1;
  int? t2;
  int? buyingpower;
  double? buypendingvl;
  int? sellpendingvl;
  int? recieve;
  int? pendinG_MATCHVL;
  int? advamt;
  int? aamt;
  int? loanvalue;
  int? totalloan;
  int? loanorderm;
  int? loanorderw;
  int? loaninday;
  int? totalvaluepl;
  double? percentpl;
  int? dividendvalue;
  int? withdrawalvalue;
  double? rtt;
  int? blockeD_VALUE;
  int? loanamt;
  int? acrintamt;
  int? mgdebt;
  int? overamt;
  int? custodyfee;
  int? otherfee;
  int? pendrightsvalue;
  int? totalmoney;
  int? cashbalanceT1;
  int? cashbalanceT2;
  int? marketvalue;
  int? holdingstock;
  int? totalasset;
  int? nav;
  int? fee;
  int? frozenvolume;
  int? costvalue;
  int? bidvbalance;

  CashInfoModel({
    this.aamt,
    this.acrintamt,
    this.advamt,
    this.afacctno,
    this.balance,
    this.bidvbalance,
    this.blockeD_VALUE,
    this.buyingpower,
    this.buypendingvl,
    this.cashbalanceT1,
    this.cashbalanceT2,
    this.costvalue,
    this.custodyfee,
    this.dividendvalue,
    this.fee,
    this.frozenvolume,
    this.holdingstock,
    this.loanamt,
    this.loaninday,
    this.loanorderm,
    this.loanorderw,
    this.loanvalue,
    this.marketvalue,
    this.mgdebt,
    this.nav,
    this.otherfee,
    this.overamt,
    this.pendinG_MATCHVL,
    this.pendrightsvalue,
    this.percentpl,
    this.recieve,
    this.rtt,
    this.sellpendingvl,
    this.t0,
    this.t1,
    this.t2,
    this.totalasset,
    this.totalloan,
    this.totalmoney,
    this.totalvaluepl,
    this.withdrawalvalue,
  });

  factory CashInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CashInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$CashInfoModelToJson(this);
}
