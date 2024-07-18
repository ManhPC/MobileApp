// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class OTPSuccess extends StatefulWidget {
  OTPSuccess({super.key, required this.textSuccess});

  String textSuccess;

  @override
  State<OTPSuccess> createState() => _OTPSuccessState();
}

class _OTPSuccessState extends State<OTPSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: ""),
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: 24,
            horizontal: (widget.textSuccess == 'register') ? 75 : 29.5),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    color: const Color(0xff292d38),
                  ),
                  padding: const EdgeInsets.all(30),
                  child: SvgPicture.asset(
                    "assets/icons/Base-lock-password.svg",
                    width: 80,
                    height: 80,
                  ),
                ),
                Positioned(
                  bottom: 30,
                  right: 10,
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xff4fd08a),
                    ),
                    child: const Icon(Icons.check),
                  ),
                ),
              ],
            ),
            Center(
              child: customTextStyleBody(
                text: widget.textSuccess,
                size: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 60,
        width: double.infinity,
        color: const Color(0xff1d2029),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: const Color(0xffe7ab21),
          ),
          onPressed: () {},
          child: customTextStyleBody(
            text: "Đăng nhập",
            size: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xff131721),
          ),
        ),
      ),
    );
  }
}
