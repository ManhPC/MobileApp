class BankInterestRateInfo {
  String bankCode;
  String bankName;
  String period;
  String perIod_Name;
  double rate;
  double pre_Rate;

  BankInterestRateInfo({
    required this.bankCode,
    required this.bankName,
    required this.period,
    required this.perIod_Name,
    required this.rate,
    required this.pre_Rate,
  });

  factory BankInterestRateInfo.fromJson(Map<String, dynamic> json) {
    return BankInterestRateInfo(
      bankCode: json['bankCode'].toString(),
      bankName: json['bankName'].toString(),
      period: json['period'].toString(),
      perIod_Name: json['perIod_Name'].toString(),
      rate: json['rate'].toDouble(),
      pre_Rate: json['pre_Rate'].toDouble(),
    );
  }
}
