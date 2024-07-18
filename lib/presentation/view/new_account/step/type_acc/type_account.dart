// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:nvs_trading/presentation/view/new_account/step/type_acc/nice_number.dart';

class TypeAccount extends StatefulWidget {
  TypeAccount(
      {super.key, required this.currentStep, required this.onNextPressed});
  int currentStep;
  VoidCallback onNextPressed;

  @override
  State<TypeAccount> createState() => _TypeAccountState();
}

class _TypeAccountState extends State<TypeAccount> {
  bool check1 = false;
  bool check2 = false;
  @override
  Widget build(BuildContext context) {
    return check2
        ? NiceNumber(
            currentStep: widget.currentStep,
            onNextPressed: widget.onNextPressed,
          )
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 30),
                    child: customTextStyleBody(
                      text: "CHỌN LOẠI TÀI KHOẢN",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: check1 ? 2 : 1,
                          color: check1
                              ? const Color(0xFFEE7420)
                              : const Color(0xFF595E72),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(0),
                    ),
                    onPressed: () {
                      setState(() {
                        check1 = !check1;
                        check2 = false;
                      });
                    },
                    child: SizedBox(
                      height: 80,
                      child: Stack(
                        children: [
                          check1
                              ? Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CustomPaint(
                                          size: const Size(40,
                                              40), // Kích thước của tam giác
                                          painter: TrianglePainter(
                                              const Color(0xFFEE7420)),
                                        ),
                                      ),
                                    ),
                                    const Align(
                                      alignment: Alignment.topRight,
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          Center(
                            child: customTextStyleBody(
                              text: "Tài khoản thường",
                              size: 24,
                              color: const Color(0xFFE2E2E2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: check2 ? 2 : 1,
                              color: check2
                                  ? const Color(0xFFEE7420)
                                  : const Color(0xFF595E72),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          )),
                      onPressed: () {
                        setState(
                          () {
                            check1 = false;
                            check2 = !check2;
                          },
                        );
                      },
                      child: SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.center,
                          child: customTextStyleBody(
                            text: "Tài khoản số đẹp",
                            size: 24,
                            color: const Color(0xFFE2E2E2),
                          ),
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
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
