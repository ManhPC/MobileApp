part of 'login_bloc.dart';

class LoginState {
  LoginState({
    this.isSaveLogin = false,
    this.custodycd = '',
    this.password = '',
  });
  bool isSaveLogin;
  final String custodycd;
  final String password;

  LoginState copyWith({
    String? custodycd,
    String? password,
    bool? isSaveLogin,
  }) {
    return LoginState(
      custodycd: custodycd ?? this.custodycd,
      password: password ?? this.password,
      isSaveLogin: isSaveLogin ?? this.isSaveLogin,
    );
  }
}
