// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:nvs_trading/presentation/view/homepage/stock_detail_screen/tai_chinh_form/cttt.dart';
import 'package:nvs_trading/presentation/view/homepage/stock_detail_screen/tai_chinh_form/vvct.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class TaiChinh extends StatefulWidget {
  TaiChinh({
    super.key,
    required this.symbol,
  });

  String symbol;
  @override
  State<TaiChinh> createState() => _TaiChinhState();
}

class _TaiChinhState extends State<TaiChinh> {
  int chooseType = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      chooseType = 0;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: (chooseType == 0)
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.primary,
                    ),
                    child: customTextStyleBody(
                      text: "Chỉ tiêu tài chính",
                      color: (chooseType == 0)
                          ? Theme.of(context).secondaryHeaderColor
                          : Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      chooseType = 1;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: (chooseType == 1)
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.primary,
                    ),
                    child: customTextStyleBody(
                      text: "Doanh thu",
                      color: (chooseType == 1)
                          ? Theme.of(context).secondaryHeaderColor
                          : Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      chooseType = 2;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: (chooseType == 2)
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.primary,
                    ),
                    child: customTextStyleBody(
                      text: "Lợi nhuận",
                      color: (chooseType == 2)
                          ? Theme.of(context).secondaryHeaderColor
                          : Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      chooseType = 3;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: (chooseType == 3)
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.primary,
                    ),
                    child: customTextStyleBody(
                      text: "Vốn và cổ tức",
                      color: (chooseType == 3)
                          ? Theme.of(context).secondaryHeaderColor
                          : Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: (chooseType == 0)
              ? CTTT(
                  symbol: widget.symbol,
                )
              : (chooseType == 1)
                  ? Container()
                  : (chooseType == 2)
                      ? Container()
                      : VVCT(
                          symbol: widget.symbol,
                        ),
        ),
      ],
    );
  }
}

class TextWidget extends StatelessWidget {
  TextWidget({
    super.key,
    required this.leftText,
    required this.rightText,
  });

  String leftText;
  String rightText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customTextStyleBody(
            text: leftText,
            color: Theme.of(context).textTheme.titleSmall!.color!,
            fontWeight: FontWeight.w400,
          ),
          customTextStyleBody(
            text: rightText,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

class Vachke extends StatelessWidget {
  const Vachke({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Theme.of(context).colorScheme.tertiary,
      height: 1,
    );
  }
}
