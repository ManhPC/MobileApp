import 'package:flutter/material.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';

class BankAccountLink extends StatefulWidget {
  const BankAccountLink({super.key});

  @override
  State<BankAccountLink> createState() => _BankAccountLinkState();
}

class _BankAccountLinkState extends State<BankAccountLink> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: "Liên kết tài khoản ngân hàng"),
    );
  }
}
