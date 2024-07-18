import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:nvs_trading/presentation/view/shared/otp.dart';

class ConfirmAccount extends StatefulWidget {
  const ConfirmAccount({super.key});

  @override
  State<ConfirmAccount> createState() => _ConfirmAccountState();
}

class _ConfirmAccountState extends State<ConfirmAccount> {
  bool check1 = false;
  bool check2 = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 30),
              child: customTextStyleBody(
                text: "XÁC NHẬN THÔNG TIN",
                fontWeight: FontWeight.w700,
              ),
            ),
            customTextStyleBody(
              text: "Họ và tên",
              color: const Color(0xFFA0A3AF),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF797F8A)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  isDense: true,
                ),
              ),
            ),
            customTextStyleBody(
              text: "Ngày sinh",
              color: const Color(0xFFA0A3AF),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF797F8A)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  isDense: true,
                ),
              ),
            ),
            customTextStyleBody(
              text: "Giới tính",
              color: const Color(0xFFA0A3AF),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF797F8A)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  isDense: true,
                ),
              ),
            ),
            customTextStyleBody(
              text: "Số điện thoại",
              color: const Color(0xFFA0A3AF),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF797F8A)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  isDense: true,
                ),
              ),
            ),
            customTextStyleBody(
              text: "Số CMND/CCCD",
              color: const Color(0xFFA0A3AF),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF797F8A)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  isDense: true,
                ),
              ),
            ),
            customTextStyleBody(
              text: "Ngày cấp",
              color: const Color(0xFFA0A3AF),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF797F8A)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  isDense: true,
                ),
              ),
            ),
            customTextStyleBody(
              text: "Nơi cấp",
              color: const Color(0xFFA0A3AF),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF797F8A)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  isDense: true,
                ),
              ),
            ),
            customTextStyleBody(
              text: "Địa chỉ hiện tại",
              color: const Color(0xFFA0A3AF),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF797F8A)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  isDense: true,
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  checkColor: Colors.black,
                  activeColor: const Color(0xFFE7AB21),
                  value: check1,
                  onChanged: (bool? value) {
                    setState(() {
                      check1 = value!;
                    });
                  },
                ),
                Expanded(
                  child: customTextStyleBody(
                    txalign: TextAlign.start,
                    text:
                        "Tôi cam kết thông tin cung cấp là chính xác, hợp pháp và hoàn toàn chịu trách nhiệm.",
                    color: const Color(0xFFA0A3AF),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                  checkColor: Colors.black,
                  activeColor: const Color(0xFFE7AB21),
                  value: check2,
                  onChanged: (bool? value) {
                    setState(() {
                      check2 = value!;
                    });
                  },
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'Tôi đồng ý với mọi ',
                      style: const TextStyle(color: Color(0xFFA0A3AF)),
                      children: [
                        TextSpan(
                          text: 'Điều khoản & điều kiện',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF69B1FF), // Màu của liên kết
                            decoration: TextDecoration.underline, // Gạch chân
                            decorationColor: Color(0xFF69B1FF),
                            decorationThickness: 2,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Đã nhấp vào Điều khoản & điều kiện');
                            },
                        ),
                        const TextSpan(
                          text: ' của CTCK',
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE7AB21),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
                onPressed: () {
                  if (check1 == true && check2 == true) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OTP(
                          options: "pay_nice_number",
                        ),
                      ),
                    );
                  } else {
                    print("Cant receive OTP");
                  }
                },
                child: customTextStyleBody(
                  text: "Tiếp tục",
                  color: const Color(0xFF131721),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
