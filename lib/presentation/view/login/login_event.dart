part of 'login_bloc.dart';

abstract class LoginEvent {
  const LoginEvent();
}

class LoginInit extends LoginEvent {
  LoginInit();
}

class IsSaveLoginChanged extends LoginEvent {
  final bool isSaveLogin;
  const IsSaveLoginChanged({
    required this.isSaveLogin,
  });
}

class IsUsernameChanged extends LoginEvent {
  final String custodycd;
  const IsUsernameChanged({
    required this.custodycd,
  });
}

class IsPasswordChanged extends LoginEvent {
  final String password;
  const IsPasswordChanged({
    required this.password,
  });
}

class LoginSubmitted extends LoginEvent {
  LoginSubmitted();
}
