// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_acctno_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankAcctnoInfo _$BankAcctnoInfoFromJson(Map<String, dynamic> json) =>
    BankAcctnoInfo(
      afAcctno: json['afAcctno'] as String,
      bankAccount: json['bankAccount'] as String,
      bankId: json['bankId'] as String,
      bankName: json['bankName'] as String,
      bankNameEn: json['bankNameEn'] as String,
      branchBank: json['branchBank'] as String,
      cif: json['cif'] as String,
      description: json['description'] as String,
      fullName: json['fullName'] as String,
      maxval: (json['maxval'] as num).toInt(),
      minval: (json['minval'] as num).toInt(),
      prate: json['prate'] as String,
      shortName: json['shortName'] as String,
      stt: (json['stt'] as num).toInt(),
    );

Map<String, dynamic> _$BankAcctnoInfoToJson(BankAcctnoInfo instance) =>
    <String, dynamic>{
      'afAcctno': instance.afAcctno,
      'bankAccount': instance.bankAccount,
      'bankId': instance.bankId,
      'bankName': instance.bankName,
      'bankNameEn': instance.bankNameEn,
      'branchBank': instance.branchBank,
      'cif': instance.cif,
      'description': instance.description,
      'fullName': instance.fullName,
      'maxval': instance.maxval,
      'minval': instance.minval,
      'prate': instance.prate,
      'shortName': instance.shortName,
      'stt': instance.stt,
    };
