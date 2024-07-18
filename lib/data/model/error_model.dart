import 'package:json_annotation/json_annotation.dart';

part 'error_model.g.dart';

@JsonSerializable()
class ErrorModel implements Exception {
  int? httpStatus;
  final int? status;
  String? message;
  final int? code;
  final String? field;

  ErrorModel(
      {this.status, this.field, this.httpStatus, this.message, this.code});

  factory ErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorModelFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorModelToJson(this);
}
