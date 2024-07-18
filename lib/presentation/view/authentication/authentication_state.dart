import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'authentication_state.g.dart';

@JsonSerializable()
class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
  factory AuthenticationState.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationStateFromJson(json);
  Map<String, dynamic> toJson() => _$AuthenticationStateToJson(this);
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {}

class Unauthenticated extends AuthenticationState {}
