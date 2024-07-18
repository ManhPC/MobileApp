class InfoOrder {
  String acctno;
  String balance;
  int buyingpower;
  int canbuyqtty;
  String tradeqtty;
  int canbuy;
  String mgdensity;

  InfoOrder({
    required this.acctno,
    required this.balance,
    required this.buyingpower,
    required this.canbuyqtty,
    required this.tradeqtty,
    required this.canbuy,
    required this.mgdensity,
  });

  factory InfoOrder.fromJson(Map<String, dynamic> json) {
    return InfoOrder(
      acctno: json['acctno'].toString(),
      balance: json['balance'].toString(),
      buyingpower: json['buyingpower'],
      canbuyqtty: json['canbuyqtty'],
      tradeqtty: json['tradeqtty'].toString(),
      canbuy: json['canbuy'],
      mgdensity: json['mgdensity'].toString(),
    );
  }
}
