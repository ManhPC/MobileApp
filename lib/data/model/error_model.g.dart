// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorModel _$ErrorModelFromJson(Map<String, dynamic> json) => ErrorModel(
      status: (json['status'] as num?)?.toInt(),
      field: json['field'] as String?,
      httpStatus: (json['httpStatus'] as num?)?.toInt(),
      message: json['message'] as String?,
      code: (json['code'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ErrorModelToJson(ErrorModel instance) =>
    <String, dynamic>{
      'httpStatus': instance.httpStatus,
      'status': instance.status,
      'message': instance.message,
      'code': instance.code,
      'field': instance.field,
    };
