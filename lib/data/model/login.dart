// ignore_for_file: must_be_immutable

class LoginModel {
  String code;
  String custodycd;
  String username;
  String token;
  String status;
  String message;

  LoginModel({
    required this.code,
    required this.username,
    required this.custodycd,
    required this.message,
    required this.status,
    required this.token,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      code: json['code'].toString(),
      message: json['message'].toString(),
      status: json['status'].toString(),
      username: json['username'].toString(),
      custodycd: json['custodycd'].toString(),
      token: json['token'].toString(),
    );
  }
}
