// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:nvs_trading/data/services/stock_detail/getRatio.dart';
import 'package:nvs_trading/presentation/view/homepage/stock_detail_screen/tai_chinh.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class CTTT extends StatefulWidget {
  CTTT({
    super.key,
    required this.symbol,
  });

  String symbol;
  @override
  State<CTTT> createState() => _CTTTState();
}

class _CTTTState extends State<CTTT> {
  dynamic data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final response = await getRatio(widget.symbol);
      if (response.statusCode == 200) {
        setState(() {
          data = response.data;
        });
      }
    } catch (e) {
      Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (data == null)
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.blue,
          ))
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Dinh gia
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Theme.of(context).colorScheme.primary,
                  child: customTextStyleBody(
                    text: "Định giá",
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    txalign: TextAlign.start,
                  ),
                ),
                Column(
                  children: [
                    TextWidget(
                      leftText: "EPS",
                      rightText:
                          "${data['objRatioTTMDaily']['rtd14'].toStringAsFixed(2)}",
                    ),
                    const Vachke(),
                  ],
                ),
                Column(
                  children: [
                    TextWidget(
                      leftText: "EPS pha loãng",
                      rightText:
                          "${data['objRatioTTMDaily']['rtd15'].toStringAsFixed(2)}",
                    ),
                    const Vachke(),
                  ],
                ),
                Column(
                  children: [
                    TextWidget(
                      leftText: "PE",
                      rightText:
                          "${data['objRatioTTMDaily']['rtd21'].toStringAsFixed(2)}",
                    ),
                    const Vachke(),
                  ],
                ),
                Column(
                  children: [
                    TextWidget(
                      leftText: "PE pha loãng",
                      rightText:
                          "${data['objRatioTTMDaily']['rtd22'].toStringAsFixed(2)}",
                    ),
                    const Vachke(),
                  ],
                ),
                TextWidget(
                  leftText: "PB",
                  rightText:
                      "${data['objRatioTTMDaily']['rtd25'].toStringAsFixed(2)}",
                ),

                // KL sinh loi
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Theme.of(context).colorScheme.primary,
                  child: customTextStyleBody(
                    text: "Khả năng sinh lời",
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    txalign: TextAlign.start,
                  ),
                ),
                Column(
                  children: [
                    TextWidget(
                      leftText: "ROE",
                      rightText:
                          "${(data['objRatioTTM']['rtq12'] * 100).toStringAsFixed(data['objRatioTTM']['rtq12'] == 0 ? 0 : 2)}",
                    ),
                    const Vachke(),
                  ],
                ),
                Column(
                  children: [
                    TextWidget(
                      leftText: "ROA",
                      rightText:
                          "${(data['objRatioTTM']['rtq14'] * 100).toStringAsFixed(data['objRatioTTM']['rtq14'] == 0 ? 0 : 2)}",
                    ),
                    const Vachke(),
                  ],
                ),
                Column(
                  children: [
                    TextWidget(
                      leftText: "ROIC",
                      rightText:
                          "${(data['objRatioTTM']['rtq13'] * 100).toStringAsFixed(data['objRatioTTM']['rtq13'] == 0 ? 0 : 2)}",
                    ),
                    const Vachke(),
                  ],
                ),
                Column(
                  children: [
                    TextWidget(
                      leftText: "Tỷ suất LN gộp",
                      rightText:
                          "${(data['objRatioTTM']['rtq76'] * 100).toStringAsFixed(data['objRatioTTM']['rtq76'] == 0 ? 0 : 2)}",
                    ),
                    const Vachke(),
                  ],
                ),
                TextWidget(
                  leftText: "Biên LN ròng",
                  rightText:
                      "${(data['objRatioTTM']['rtq25'] * 100).toStringAsFixed(data['objRatioTTM']['rtq25'] == 0 ? 0 : 2)}",
                ),

                // SM tai chinh
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Theme.of(context).colorScheme.primary,
                  child: customTextStyleBody(
                    text: "Khả năng sinh lời",
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    txalign: TextAlign.start,
                  ),
                ),
                Column(
                  children: [
                    TextWidget(
                      leftText: "Tổng nợ/VCSH",
                      rightText:
                          "${(data['objRatioTTM']['rtq10']).toStringAsFixed(data['objRatioTTM']['rtq10'] == 0 ? 0 : 2)}",
                    ),
                    const Vachke(),
                  ],
                ),
                Column(
                  children: [
                    TextWidget(
                      leftText: "Tổng nợ/Tổng TS",
                      rightText:
                          "${(data['objRatioTTM']['rtq11']).toStringAsFixed(data['objRatioTTM']['rtq11'] == 0 ? 0 : 2)}",
                    ),
                    const Vachke(),
                  ],
                ),
                Column(
                  children: [
                    TextWidget(
                      leftText: "Thanh toán nhanh",
                      rightText:
                          "${(data['objRatioTTM']['rtq2']).toStringAsFixed(data['objRatioTTM']['rtq2'] == 0 ? 0 : 2)}",
                    ),
                    const Vachke(),
                  ],
                ),

                Column(
                  children: [
                    TextWidget(
                        leftText: "Thanh toán hiện hành",
                        rightText:
                            "${(data['objRatioTTM']['rtq3']).toStringAsFixed(data['objRatioTTM']['rtq3'] == 0 ? 0 : 2)}"),
                    const Vachke(),
                  ],
                ),
                TextWidget(
                  leftText: "Biên LN ròng(%)",
                  rightText:
                      "${(data['objRatioTTM']['rtq29'] * 100).toStringAsFixed(data['objRatioTTM']['rtq29'] == 0 ? 0 : 2)}",
                ),
              ],
            ),
          );
  }
}
