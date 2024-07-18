class PartnerBankModel {
  String bankId;
  String bankName;
  String shortName;
  String description;

  PartnerBankModel({
    required this.bankId,
    required this.bankName,
    required this.shortName,
    required this.description,
  });

  factory PartnerBankModel.fromJson(Map<String, dynamic> json) {
    return PartnerBankModel(
      bankId: json['bankId'].toString(),
      bankName: json['bankName'].toString(),
      shortName: json['shortName'].toString(),
      description: json['description'].toString(),
    );
  }
}
