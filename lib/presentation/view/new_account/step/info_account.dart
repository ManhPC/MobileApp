// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class InfoAccount extends StatefulWidget {
  InfoAccount(
      {super.key, required this.currentStep, required this.onNextPressed});
  int currentStep;
  VoidCallback onNextPressed;

  @override
  State<InfoAccount> createState() => _InfoAccountState();
}

class _InfoAccountState extends State<InfoAccount> {
  String _dropdownValue = "VN";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 30),
              child: customTextStyleBody(
                text: "THÔNG TIN LIÊN LẠC",
                fontWeight: FontWeight.w700,
              ),
            ),
            customTextStyleBody(
              text: "Họ và tên",
              size: 14,
              color: const Color(0xFFE2E2E2),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF595E72)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  isDense: true,
                  hintText: "Họ và tên",
                  hintStyle: TextStyle(
                    color: Color(0xFF8A8779),
                  ),
                ),
              ),
            ),
            customTextStyleBody(
              text: "Email",
              size: 14,
              color: const Color(0xFFE2E2E2),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF595E72)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  isDense: true,
                  hintText: "Email",
                  hintStyle: TextStyle(
                    color: Color(0xFF8A8779),
                  ),
                ),
              ),
            ),
            customTextStyleBody(
              text: "Số điện thoại",
              size: 14,
              color: const Color(0xFFE2E2E2),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFF595E72)),
                          top: BorderSide(color: Color(0xFF595E72)),
                          left: BorderSide(color: Color(0xFF595E72)),
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: DropdownButton(
                        isDense: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 9),
                        items: const [
                          DropdownMenuItem(
                            alignment: Alignment.center,
                            value: "VN",
                            child: Text(
                              '\u{1F1FB}\u{1F1F3}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          DropdownMenuItem(
                            alignment: Alignment.center,
                            value: "EN",
                            child: Text(
                              '\u{1F1EC}\u{1F1E7}',
                              style: TextStyle(fontSize: 20),
                            ),
                          )
                        ],
                        value: _dropdownValue,
                        onChanged: dropdownCallback,
                        underline: Container(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9]'),
                        ),
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF595E72)),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        isDense: true,
                        hintText: "Số điện thoại",
                        hintStyle: TextStyle(
                          color: Color(0xFF8A8779),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            customTextStyleBody(
              text: "Mã nhân viên tư vấn (không bắt buộc)",
              size: 14,
              color: const Color(0xFFE2E2E2),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF595E72)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  isDense: true,
                  hintText: "Mã nhân viên tư vấn",
                  hintStyle: TextStyle(
                    color: Color(0xFF8A8779),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: const Color(0xFF1D2029),
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE7AB21),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            if (widget.currentStep != 5) {
              widget.onNextPressed();
            }
          },
          child: customTextStyleBody(
            text: "Tiếp theo",
            size: 14,
            color: const Color(0xFF131721),
          ),
        ),
      ),
    );
  }

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }
}
