import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nvs_trading/presentation/view/expand/Settings/loss_warning/list_warning.dart';
import 'package:nvs_trading/presentation/view/expand/Settings/loss_warning/setting_warning.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LossWarning extends StatefulWidget {
  const LossWarning({super.key});

  @override
  State<LossWarning> createState() => _LossWarningState();
}

class _LossWarningState extends State<LossWarning> {
  bool _isSelected = false;
  int currentIndexPage = 0;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(text: appLocal.losswarning('title')),
      body: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSelected = false;
                    currentIndexPage = 0;
                  });
                  _pageController.animateToPage(
                    currentIndexPage,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: (_isSelected || (currentIndexPage != 0))
                          ? BorderSide.none
                          : BorderSide(
                              color: Theme.of(context).secondaryHeaderColor),
                    ),
                  ),
                  alignment: Alignment.center,
                  height: 45,
                  width: 127,
                  child: customTextStyleBody(
                    text: appLocal.losswarning('choice1'),
                    size: 14,
                    color: (_isSelected || (currentIndexPage != 0))
                        ? Theme.of(context).textTheme.titleSmall!.color!
                        : Theme.of(context).secondaryHeaderColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSelected = true;
                    currentIndexPage = 1;
                  });
                  _pageController.animateToPage(
                    currentIndexPage,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: (_isSelected || (currentIndexPage == 1))
                          ? BorderSide(
                              color: Theme.of(context).secondaryHeaderColor)
                          : BorderSide.none,
                    ),
                  ),
                  alignment: Alignment.center,
                  height: 45,
                  width: 146,
                  child: customTextStyleBody(
                    text: appLocal.losswarning('choice2'),
                    size: 14,
                    color: (_isSelected || (currentIndexPage == 1))
                        ? Theme.of(context).secondaryHeaderColor
                        : Theme.of(context).textTheme.titleSmall!.color!,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: 1,
            color: Theme.of(context).hintColor,
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: 2,
              onPageChanged: (value) {
                setState(() {
                  currentIndexPage = value;
                  _isSelected = value == 1;
                });
              },
              itemBuilder: (_, i) {
                if (i == 0) {
                  return SettingWarning(
                    pageController: _pageController,
                  );
                } else {
                  return const ListWarning();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
