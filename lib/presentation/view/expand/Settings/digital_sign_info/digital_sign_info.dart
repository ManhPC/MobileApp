import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/data/services/getBusDate.dart';
import 'package:nvs_trading/presentation/view/expand/Settings/digital_sign_info/dang_ky_digital_sign.dart';
import 'package:nvs_trading/presentation/view/expand/Settings/digital_sign_info/list_digital_sign.dart';
import 'package:nvs_trading/presentation/widget/appbarExtend.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DigitalSignInfo extends StatefulWidget {
  const DigitalSignInfo({super.key});

  @override
  State<DigitalSignInfo> createState() => _DigitalSignInfoState();
}

class _DigitalSignInfoState extends State<DigitalSignInfo> {
  bool _isSelected = false;
  int currentIndexPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    fetchBusDate();
  }

  void fetchBusDate() async {
    final response = await GetBusDate(HydratedBloc.storage.read('token'));
    if (response.statusCode == 200) {
      print(response.data['dateserver']);
    }
  }

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(text: appLocal.digitalSignature('title')),
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
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                    ),
                  ),
                  alignment: Alignment.center,
                  height: 45,
                  width: 127,
                  child: customTextStyleBody(
                    text: appLocal.digitalSignature('choice1'),
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
                    text: appLocal.digitalSignature('choice2'),
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
                  return DangKyDigitalSign(
                    pageController: _pageController,
                  );
                } else {
                  return ListDigitalSign(
                    pageController: _pageController,
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
