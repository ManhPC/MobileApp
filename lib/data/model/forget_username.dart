class ForgotUsername {
  final String custodycd;
  final String fullname;

  ForgotUsername({
    required this.custodycd,
    required this.fullname,
  });

  factory ForgotUsername.fromJson(Map<String, dynamic> json) {
    return ForgotUsername(
      custodycd: json['custodycd'].toString(),
      fullname: json['fullname'].toString(),
    );
  }
}
