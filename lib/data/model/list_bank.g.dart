// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_bank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListBank _$ListBankFromJson(Map<String, dynamic> json) => ListBank(
      bankid: json['bankid'] as String,
      bankname: json['bankname'] as String,
      bankname_en: json['bankname_en'] as String,
      minval: json['minval'] as String,
      napasmember: json['napasmember'] as String,
      prate: json['prate'] as String,
      shortname: json['shortname'] as String,
    );

Map<String, dynamic> _$ListBankToJson(ListBank instance) => <String, dynamic>{
      'bankid': instance.bankid,
      'bankname': instance.bankname,
      'bankname_en': instance.bankname_en,
      'minval': instance.minval,
      'napasmember': instance.napasmember,
      'prate': instance.prate,
      'shortname': instance.shortname,
    };
