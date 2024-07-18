// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:nvs_trading/presentation/widget/dialog_cancel_all.dart';
import 'package:nvs_trading/presentation/widget/titleTableText.dart';

class ConditionalOrder extends StatefulWidget {
  const ConditionalOrder({super.key});

  @override
  State<ConditionalOrder> createState() => _ConditionalOrderState();
}

class _ConditionalOrderState extends State<ConditionalOrder> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: TextButton(
            onPressed: () {},
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/icons/candle-2.svg",
                  height: 16,
                  width: 16,
                ),
                const SizedBox(
                  width: 4,
                ),
                customTextStyleBody(
                  text: "Bộ lọc",
                  color: const Color(0xFFE7AB21),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 36,
          child: Row(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: SearchBar(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  leading: SvgPicture.asset(
                    "assets/icons/ic_search.svg",
                    width: 20,
                    height: 20,
                  ),
                  hintText: "Mã CK",
                  hintStyle: const MaterialStatePropertyAll(
                    TextStyle(
                      color: Color(0xFF797F8A),
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF04A47),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
                onPressed: () {
                  dialog_request(context, "Hủy tất cả",
                      "Bạn có muốn hủy tất cả các lệnh đang chờ", _handleOK);
                },
                child: customTextStyleBody(
                  text: "Hủy tất cả",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            titleText(text: "Mã Ck"),
            titleText(text: "M/B"),
            titleText(text: "KL"),
            titleText(text: "Đặt"),
            titleText(text: "ĐK KH"),
            SizedBox(
              width: 71,
              child: Align(
                alignment: Alignment.centerLeft,
                child: titleText(text: "TT"),
              ),
            ),
          ],
        )
      ],
    );
  }
}

void _handleOK() {
  print("Ok 123");
}
