import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String token;
  final String custodycd;
  final String password;

  LoggedIn(this.token, this.custodycd, this.password);

  @override
  List<Object> get props => [token, custodycd, password];
}

class LoggedOut extends AuthenticationEvent {}

class Unauthentication extends AuthenticationEvent {}
