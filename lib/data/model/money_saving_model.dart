class MoneySavingModel {
  String savingId;
  String bankSavingCode;
  String bankName;
  String balance;
  int rate_val;
  double rate;
  String period;
  String period_Name;
  String frDate;
  String toDate;
  String hinhThucDaoHan_Name;
  int numReNew;
  String status;
  String status_Name;
  String status_Name_En;

  MoneySavingModel({
    required this.savingId,
    required this.bankSavingCode,
    required this.bankName,
    required this.balance,
    required this.rate_val,
    required this.rate,
    required this.period,
    required this.period_Name,
    required this.frDate,
    required this.toDate,
    required this.hinhThucDaoHan_Name,
    required this.numReNew,
    required this.status,
    required this.status_Name,
    required this.status_Name_En,
  });
  factory MoneySavingModel.fromJson(Map<String, dynamic> json) {
    return MoneySavingModel(
      savingId: json['savingId'].toString(),
      bankSavingCode: json['bankSavingCode'].toString(),
      bankName: json['bankName'].toString(),
      balance: json['balance'].toString(),
      rate_val: json['rate_val'],
      rate: json['rate'],
      period: json['period'].toString(),
      period_Name: json['period_Name'].toString(),
      frDate: json['frDate'].toString(),
      toDate: json['toDate'].toString(),
      hinhThucDaoHan_Name: json['hinhThucDaoHan_Name'].toString(),
      numReNew: json['numReNew'],
      status: json['status'].toString(),
      status_Name: json['status_Name'].toString(),
      status_Name_En: json['status_Name_En'].toString(),
    );
  }
}
