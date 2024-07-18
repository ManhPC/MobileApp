class GetAccountDetailModel {
  String acctno;
  String fullname;
  int balance;

  GetAccountDetailModel({
    required this.acctno,
    required this.fullname,
    required this.balance,
  });
  factory GetAccountDetailModel.fromjson(Map<String, dynamic> json) {
    return GetAccountDetailModel(
      acctno: json['acctno'].toString(),
      fullname: json['fullname'].toString(),
      balance: json['balance'],
    );
  }
}
