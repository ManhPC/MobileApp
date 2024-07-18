import 'package:flutter/material.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';

class GetOTP extends StatefulWidget {
  const GetOTP({super.key});

  @override
  State<GetOTP> createState() => _GetOTPState();
}

class _GetOTPState extends State<GetOTP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: ""),
    );
  }
}
