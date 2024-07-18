import 'package:flutter/material.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';

class PaymentByQr extends StatefulWidget {
  const PaymentByQr({super.key});

  @override
  State<PaymentByQr> createState() => _PaymentByQrState();
}

class _PaymentByQrState extends State<PaymentByQr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: "Nộp tiền bằng QR Code"),
    );
  }
}
