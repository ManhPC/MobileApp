import 'package:flutter/material.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';

class PaymentByLinkAcc extends StatefulWidget {
  const PaymentByLinkAcc({super.key});

  @override
  State<PaymentByLinkAcc> createState() => _PaymentByLinkAccState();
}

class _PaymentByLinkAccState extends State<PaymentByLinkAcc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: "Nộp tiền bằng tài khoản liên kết"),
    );
  }
}
