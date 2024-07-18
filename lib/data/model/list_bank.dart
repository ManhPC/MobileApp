import 'package:json_annotation/json_annotation.dart';

part 'list_bank.g.dart';

@JsonSerializable()
class ListBank {
  String bankid;
  String bankname;
  String bankname_en;
  String minval;
  String napasmember;
  String prate;
  String shortname;

  ListBank({
    required this.bankid,
    required this.bankname,
    required this.bankname_en,
    required this.minval,
    required this.napasmember,
    required this.prate,
    required this.shortname,
  });
  factory ListBank.fromJson(Map<String, dynamic> json) =>
      _$ListBankFromJson(json);
  Map<String, dynamic> toJson() => _$ListBankToJson(this);
}
