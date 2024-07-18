class CustomerInfo {
  String acctnodefault;
  String acctno;
  String manty;

  CustomerInfo({
    required this.acctnodefault,
    required this.acctno,
    required this.manty,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      acctnodefault: json['acctnodefault'].toString(),
      acctno: json['acctno'].toString(),
      manty: json['manty'].toString(),
    );
  }
}
