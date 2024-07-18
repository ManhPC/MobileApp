import 'package:json_annotation/json_annotation.dart';

part 'bank_acctno_info.g.dart';

@JsonSerializable()
class BankAcctnoInfo {
  String afAcctno;
  String bankAccount;
  String bankId;
  String bankName;
  String bankNameEn;
  String branchBank;
  String cif;
  String description;
  String fullName;
  int maxval;
  int minval;
  String prate;
  String shortName;
  int stt;

  BankAcctnoInfo({
    required this.afAcctno,
    required this.bankAccount,
    required this.bankId,
    required this.bankName,
    required this.bankNameEn,
    required this.branchBank,
    required this.cif,
    required this.description,
    required this.fullName,
    required this.maxval,
    required this.minval,
    required this.prate,
    required this.shortName,
    required this.stt,
  });
  factory BankAcctnoInfo.fromJson(Map<String, dynamic> json) =>
      _$BankAcctnoInfoFromJson(json);
  Map<String, dynamic> toJson() => _$BankAcctnoInfoToJson(this);
}
