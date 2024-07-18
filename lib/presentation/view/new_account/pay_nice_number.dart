import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:nvs_trading/presentation/widget/style/style_appbar.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class PayNiceNumber extends StatefulWidget {
  const PayNiceNumber({super.key});

  @override
  State<PayNiceNumber> createState() => _PayNiceNumberState();
}

class _PayNiceNumberState extends State<PayNiceNumber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customTextStyleAppbar(text: "Thanh toán tài khoản số đẹp"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 14,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D2029),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: customTextStyleBody(
                            text: "QUÉT MÃ QR ĐỂ CHUYỂN TIỀN",
                            size: 16,
                            color: const Color(0xFFA0A3AF),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: customTextStyleBody(
                            text: "CÔNG TY CHỨNG KHOÁN CTCK",
                            size: 14,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: customTextStyleBody(
                            text: "12345678900123",
                            size: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Container(
                            decoration: DottedDecoration(
                              dash: const [15, 15],
                              color: const Color(0xFFA0A3AF),
                              strokeWidth: 1,
                              linePosition: LinePosition.top,
                            ),
                            width: double.infinity,
                          ),
                        ),
                        Image.network(
                          'https://qrcode-gen.com/images/qrcode-default.png',
                          scale: 3.25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D2029),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTextStyleBody(
                          text: "Thông tin hóa đơn của bạn",
                          size: 14,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          width: double.infinity,
                          height: 1,
                          color: const Color(0xFFD3D3D3),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customTextStyleBody(
                                  text: "Tài khoản số đẹp",
                                  color: const Color(0xFFE2E2E2),
                                ),
                                customTextStyleBody(
                                  text: "811304",
                                  color: const Color(0xFFE2E2E2),
                                ),
                              ],
                            ),
                            customTextStyleBody(
                              text: "500,000",
                              size: 14,
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          width: double.infinity,
                          height: 1,
                          color: const Color(0xFFD3D3D3),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customTextStyleBody(
                              text: "Số tiền",
                              color: const Color(0xFFE2E2E2),
                            ),
                            customTextStyleBody(
                              text: "500,000",
                              size: 14,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customTextStyleBody(
                              text: "Thuế GTGT (10%)",
                              color: const Color(0xFFE2E2E2),
                            ),
                            customTextStyleBody(
                              text: "50,000",
                              size: 14,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customTextStyleBody(
                                text: "Tổng số tiền thanh toán",
                                color: const Color(0xFFEE7420),
                              ),
                              customTextStyleBody(
                                text: "550,000",
                                color: const Color(0xFFEE7420),
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE7AB21),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    onPressed: () {
                      print("Đã thanh toán");
                    },
                    child: customTextStyleBody(
                      text: "Tiếp tục",
                      color: const Color(0xFF131721),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
