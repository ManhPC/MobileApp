class OTPInfo {
  final String otpId;
  final String otpTime;
  final String phoneLastThree;

  OTPInfo({
    required this.otpId,
    required this.otpTime,
    required this.phoneLastThree,
  });

  factory OTPInfo.fromJson(Map<String, dynamic> json) {
    return OTPInfo(
      otpId: json['otpID'].toString(),
      otpTime: json['otpTime'].toString(),
      phoneLastThree: json['phoneLastThree'].toString(),
    );
  }
}
