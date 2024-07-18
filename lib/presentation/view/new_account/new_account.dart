// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:nvs_trading/presentation/widget/style/style_appbar.dart';
import 'package:nvs_trading/presentation/view/new_account/step/confirm_acc.dart';
import 'package:nvs_trading/presentation/view/new_account/step/info_account.dart';
import 'package:nvs_trading/presentation/view/new_account/step/scan_CCCD.dart';
import 'package:nvs_trading/presentation/view/new_account/step/scan_sign.dart';
import 'package:nvs_trading/presentation/view/new_account/step/type_acc/type_account.dart';

class NewAccount extends StatefulWidget {
  const NewAccount({super.key});

  @override
  State<NewAccount> createState() => _NewAccountState();
}

class _NewAccountState extends State<NewAccount> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customTextStyleAppbar(text: "Mở tài khoản"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (_currentIndex > 0) {
              setState(() {
                _currentIndex -= 1;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 14,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Row(
              children: [
                StepperWidget(
                  currentIndex: _currentIndex,
                  index: 0,
                  s: "1",
                  onTap: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                ),
                StepperWidget(
                  currentIndex: _currentIndex,
                  index: 1,
                  s: "2",
                  onTap: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                ),
                StepperWidget(
                  currentIndex: _currentIndex,
                  index: 2,
                  s: "3",
                  onTap: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                  },
                ),
                StepperWidget(
                  currentIndex: _currentIndex,
                  index: 3,
                  s: "4",
                  onTap: () {
                    setState(() {
                      _currentIndex = 3;
                    });
                  },
                ),
                StepperWidget(
                  currentIndex: _currentIndex,
                  index: 4,
                  s: "5",
                  onTap: () {
                    setState(() {
                      _currentIndex = 4;
                    });
                  },
                ),
                StepperWidget(
                  currentIndex: _currentIndex,
                  index: 5,
                  s: "6",
                  onTap: () {
                    setState(() {
                      _currentIndex = 5;
                    });
                  },
                  isLast: true,
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: 1,
              itemBuilder: (context, index) {
                index = _currentIndex;
                if (index == 0) {
                  return InfoAccount(
                    currentStep: _currentIndex,
                    onNextPressed: handleNextPressed,
                  );
                }
                if (index == 1) {
                  return TypeAccount(
                    currentStep: _currentIndex,
                    onNextPressed: handleNextPressed,
                  );
                }
                if (index == 2) {
                  return const ScanCCCD();
                }
                if (index == 3) {
                  return const Text("Nhận diện khuôn mặt");
                }
                if (index == 4) {
                  return const ScanSign();
                }
                if (index == 5) {
                  return const ConfirmAccount();
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  void handleNextPressed() {
    setState(() {
      _currentIndex += 1;
    });
  }
}

class StepperWidget extends StatelessWidget {
  StepperWidget({
    super.key,
    required this.index,
    required this.currentIndex,
    required this.s,
    required this.onTap,
    this.isLast = false,
  });
  String s;
  int index;
  int currentIndex;
  VoidCallback onTap;
  bool isLast;

  @override
  Widget build(BuildContext context) {
    return isLast
        ? Row(
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color(0xFF292D38),
                    border: Border.all(
                      color: (currentIndex >= index)
                          ? const Color(0xFFE7AB21)
                          : const Color(0xFF292D38),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      s,
                      style: TextStyle(
                          color: (currentIndex >= index)
                              ? const Color(0xFFE7AB21)
                              : const Color(0xFFE2E2E2)),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Expanded(
            child: Row(
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xFF292D38),
                      border: Border.all(
                          color: (currentIndex >= index)
                              ? const Color(0xFFE7AB21)
                              : const Color(0xFF292D38)),
                    ),
                    child: Center(
                        child: Text(
                      s,
                      style: TextStyle(
                          color: (currentIndex >= index)
                              ? const Color(0xFFE7AB21)
                              : const Color(0xFFE2E2E2)),
                    )),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 2,
                    color: const Color(0xFF292D38),
                  ),
                ),
              ],
            ),
          );
  }
}
