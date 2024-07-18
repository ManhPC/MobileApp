class CASignRegistration {
  int autoId;
  String personal_UserId;
  String personal_Pass;
  String fromDate;
  String toDate;
  String status_Vn;
  String description;

  CASignRegistration(
      {required this.autoId,
      required this.personal_UserId,
      required this.personal_Pass,
      required this.fromDate,
      required this.toDate,
      required this.status_Vn,
      required this.description});
  factory CASignRegistration.fromJson(Map<String, dynamic> json) {
    return CASignRegistration(
      autoId: json['autoId'],
      personal_UserId: json['personal_UserId'].toString(),
      personal_Pass: json['personal_Pass'].toString(),
      fromDate: json['fromDate'].toString(),
      toDate: json['toDate'].toString(),
      status_Vn: json['status_Vn'].toString(),
      description: json['description'].toString(),
    );
  }
}
