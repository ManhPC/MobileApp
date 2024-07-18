// ignore_for_file: non_constant_identifier_names

class AccountInfoModel {
  String allowadjust;
  String custodycd;
  String custid;
  String fullname;
  String idcode;
  String iddate;
  String idplace;
  String address;
  String phone;
  String mobile;
  String email;
  String custtype;
  String custtypE_TEXT;
  String custtypE_TEXT_EN;
  String brname;
  String statuS_TEXT;
  String statuS_TEXT_EN;

  AccountInfoModel({
    required this.allowadjust,
    required this.custodycd,
    required this.custid,
    required this.fullname,
    required this.idcode,
    required this.iddate,
    required this.idplace,
    required this.address,
    required this.phone,
    required this.mobile,
    required this.email,
    required this.custtype,
    required this.custtypE_TEXT,
    required this.custtypE_TEXT_EN,
    required this.brname,
    required this.statuS_TEXT,
    required this.statuS_TEXT_EN,
  });

  factory AccountInfoModel.fromJson(Map<String, dynamic> json) {
    return AccountInfoModel(
      allowadjust: json['allowadjust'].toString(),
      custodycd: json['custodycd'].toString(),
      custid: json['custid'].toString(),
      fullname: json['fullname'].toString(),
      idcode: json['idcode'].toString(),
      iddate: json['iddate'].toString(),
      idplace: json['idplace'].toString(),
      address: json['address'].toString(),
      phone: json['phone'].toString(),
      mobile: json['mobile'].toString(),
      email: json['email'].toString(),
      custtype: json['custtype'].toString(),
      custtypE_TEXT: json['custtypE_TEXT'].toString(),
      custtypE_TEXT_EN: json['custtypE_TEXT_EN'].toString(),
      brname: json['brname'].toString(),
      statuS_TEXT: json['statuS_TEXT'].toString(),
      statuS_TEXT_EN: json['statuS_TEXT_EN'].toString(),
    );
  }
}
