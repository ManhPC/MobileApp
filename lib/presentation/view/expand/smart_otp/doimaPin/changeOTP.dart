import 'package:flutter/material.dart';
import 'package:nvs_trading/presentation/view/expand/smart_otp/thietlapmaPin/registerOTP.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class ChangeOTP extends StatefulWidget {
  const ChangeOTP({super.key});

  @override
  State<ChangeOTP> createState() => _ChangeOTPState();
}

class _ChangeOTPState extends State<ChangeOTP> {
  String enteredPin = '';
  bool isPinComplete() {
    return enteredPin.length == 6;
  }

  Widget numButton(int number) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 36),
      child: TextButton(
        style: TextButton.styleFrom(
          fixedSize: const Size(60, 60),
          shape: const CircleBorder(
            side: BorderSide(
              color: Color(0xff292d38),
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            if (enteredPin.length < 6) {
              enteredPin += number.toString();
              print(enteredPin);
            }
            if (isPinComplete()) {
              // Chuyển sang trang mới
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterOTP(
                    typeOTP: 'change',
                  ),
                ),
              );
            }
          });
        },
        child: customTextStyleBody(
          text: number.toString(),
          size: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text: ""),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 16,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: customTextStyleBody(
              text: "Mã PIN hiện tại",
              size: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          customTextStyleBody(
            text: "Nhập mã PIN hiện tại để xác nhận thay đổi mã PIN.",
            size: 14,
            color: const Color(0xffe2e2e2),
            fontWeight: FontWeight.w400,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, bottom: 164),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                6,
                (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (index < enteredPin.length)
                          ? const Color(0xffe7ab21)
                          : const Color(0xff1d2029),
                      border: (index < enteredPin.length)
                          ? const Border()
                          : Border.all(color: const Color(0xff292d38)),
                    ),
                  );
                },
              ),
            ),
          ),
          for (var i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  3,
                  (index) => numButton(1 + 3 * i + index),
                ).toList(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const SizedBox(),
                ),
                numButton(0),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (enteredPin.isNotEmpty) {
                        enteredPin =
                            enteredPin.substring(0, enteredPin.length - 1);
                      }
                    });
                  },
                  child: const Icon(
                    Icons.backspace_outlined,
                    size: 30,
                    color: Color(0xffe2e2e2),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
