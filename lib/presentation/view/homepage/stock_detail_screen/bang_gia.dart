// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nvs_trading/common/utils/extensions/string_extensions.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/services/stock_detail/getStockMatch.dart';
import 'package:nvs_trading/presentation/theme/color.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_cubit.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_state.dart';
import 'package:nvs_trading/presentation/widget/highlight.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BangGia extends StatefulWidget {
  BangGia({
    super.key,
    required this.symbol,
  });
  String symbol;

  @override
  State<BangGia> createState() => _BangGiaState();
}

class _BangGiaState extends State<BangGia> {
  List<dynamic> dataKhopLenh = [];
  String lastTicks = "0";

  Timer? _timer;
  bool isFirstFetch = false;
  @override
  void initState() {
    super.initState();

    startFetchingData();
  }

  void startFetchingData() {
    if (!isFirstFetch) {
      fetchDataKL();
      isFirstFetch = true;
    } else {
      _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
        fetchDataKL();
      });
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    startFetchingData();
  }

  void fetchDataKL() async {
    try {
      final res = await getStockMatch(widget.symbol, lastTicks);
      if (res.statusCode == 200) {
        setState(() {
          dataKhopLenh = res.data;
        });
      }
    } catch (e) {
      Future.error(e);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Column(
        children: [
          BlocBuilder<MarketInfoCubit, MarketInfoState>(
            builder: (context, state) {
              final marketInfo = state.marketInfo[widget.symbol];
              final colors = Theme.of(context).primaryColor;
              final theme = Theme.of(context);
              var bQtty1 = marketInfo?.bidQtty1 ?? 0;
              var bQtty2 = marketInfo?.bidQtty2 ?? 0;
              var bQtty3 = marketInfo?.bidQtty3 ?? 0;
              var oQtty1 = marketInfo?.offerQtty1 ?? 0;
              var oQtty2 = marketInfo?.offerQtty2 ?? 0;
              var oQtty3 = marketInfo?.offerQtty3 ?? 0;
              var maxQtty = max<int>(
                  max(max(bQtty1, bQtty2), max(bQtty3, oQtty1)),
                  max(oQtty2, oQtty3));
              if (maxQtty == 0) {
                maxQtty = 1;
              }
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 38) / 2,
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customTextStyleBody(
                                text: appLocal.addCommandForm('Bvol'),
                                color: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .color!,
                                fontWeight: FontWeight.w500,
                              ),
                              customTextStyleBody(
                                text: appLocal.addCommandForm('Bpri'),
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff4FD08A),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 38) / 2,
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customTextStyleBody(
                                text: appLocal.addCommandForm('Spri'),
                                fontWeight: FontWeight.w500,
                                color: const Color(0xffF04A47),
                              ),
                              customTextStyleBody(
                                text: appLocal.addCommandForm('Svol'),
                                color: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .color!,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 38) / 2,
                          height: 68,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 60,
                                    child: HighLight(
                                      symbol: marketInfo?.symbol,
                                      textStyle:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      value: "$bQtty1".isValidNumber
                                          ? double.tryParse(bQtty1.toString())
                                          : null,
                                      type: HighLightType.PRICE,
                                      child: Text(
                                        Utils().formatNumber(bQtty1),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: (MediaQuery.of(context).size.width -
                                                38) /
                                            2 -
                                        60,
                                    height: 20,
                                    alignment: Alignment.centerRight,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width: (bQtty1 / maxQtty) *
                                              ((MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          38) /
                                                      2 -
                                                  60),
                                          decoration: BoxDecoration(
                                            color: backgroundColorRealTime[
                                                marketInfo?.bidPrice1Color],
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        ),
                                        Positioned(
                                          right: 4,
                                          top: 1,
                                          child: HighLight(
                                            symbol: marketInfo?.symbol,
                                            textStyle: theme
                                                .textTheme.bodyMedium
                                                ?.copyWith(
                                              color: colorRealTime[
                                                  marketInfo?.bidPrice1Color],
                                            ),
                                            value: "${marketInfo?.bidPrice1}"
                                                    .isValidNumber
                                                ? double.tryParse(marketInfo
                                                        ?.bidPrice1Color
                                                        .toString() ??
                                                    '0')
                                                : null,
                                            type: HighLightType.PRICE,
                                            child: Text(
                                                "${marketInfo?.bidPrice1 ?? 0}"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 60,
                                    child: HighLight(
                                      symbol: marketInfo?.symbol,
                                      textStyle:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      value: "$bQtty2".isValidNumber
                                          ? double.tryParse(bQtty2.toString())
                                          : null,
                                      type: HighLightType.PRICE,
                                      child: Text(
                                        Utils().formatNumber(bQtty2),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: (MediaQuery.of(context).size.width -
                                                38) /
                                            2 -
                                        60,
                                    height: 20,
                                    alignment: Alignment.centerRight,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width: (bQtty2 / maxQtty) *
                                              ((MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          38) /
                                                      2 -
                                                  60),
                                          decoration: BoxDecoration(
                                            color: backgroundColorRealTime[
                                                marketInfo?.bidPrice2Color],
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        ),
                                        Positioned(
                                          right: 4,
                                          top: 1,
                                          child: HighLight(
                                            symbol: marketInfo?.symbol,
                                            textStyle: theme
                                                .textTheme.bodyMedium
                                                ?.copyWith(
                                              color: colorRealTime[
                                                  marketInfo?.bidPrice2Color],
                                            ),
                                            value: "${marketInfo?.bidPrice2}"
                                                    .isValidNumber
                                                ? double.tryParse(marketInfo
                                                        ?.bidPrice2Color
                                                        .toString() ??
                                                    '0')
                                                : null,
                                            type: HighLightType.PRICE,
                                            child: Text(
                                                "${marketInfo?.bidPrice2 ?? 0}"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 60,
                                    child: HighLight(
                                      symbol: marketInfo?.symbol,
                                      textStyle:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      value: "$bQtty3".isValidNumber
                                          ? double.tryParse(bQtty3.toString())
                                          : null,
                                      type: HighLightType.PRICE,
                                      child: Text(
                                        Utils().formatNumber(bQtty3),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: (MediaQuery.of(context).size.width -
                                                38) /
                                            2 -
                                        60,
                                    height: 20,
                                    alignment: Alignment.centerRight,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width: (bQtty3 / maxQtty) *
                                              ((MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          38) /
                                                      2 -
                                                  60),
                                          decoration: BoxDecoration(
                                            color: backgroundColorRealTime[
                                                marketInfo?.bidPrice3Color],
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        ),
                                        Positioned(
                                          right: 4,
                                          top: 1,
                                          child: HighLight(
                                            symbol: marketInfo?.symbol,
                                            textStyle: theme
                                                .textTheme.bodyMedium
                                                ?.copyWith(
                                              color: colorRealTime[
                                                  marketInfo?.bidPrice3Color],
                                            ),
                                            value: "${marketInfo?.bidPrice3}"
                                                    .isValidNumber
                                                ? double.tryParse(marketInfo
                                                        ?.bidPrice3Color
                                                        .toString() ??
                                                    '0')
                                                : null,
                                            type: HighLightType.PRICE,
                                            child: Text(
                                                "${marketInfo?.bidPrice3 ?? 0}"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 38) / 2,
                          height: 68,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: (MediaQuery.of(context).size.width -
                                                38) /
                                            2 -
                                        60,
                                    height: 20,
                                    alignment: Alignment.centerLeft,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width: (oQtty1 / maxQtty) *
                                              ((MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          38) /
                                                      2 -
                                                  60),
                                          decoration: BoxDecoration(
                                            color: backgroundColorRealTime[
                                                    marketInfo
                                                        ?.offerPrice1Color] ??
                                                colors,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        ),
                                        Positioned(
                                          left: 4,
                                          top: 1,
                                          child: HighLight(
                                            symbol: marketInfo?.symbol,
                                            textStyle: theme
                                                .textTheme.bodyMedium
                                                ?.copyWith(
                                              color: colorRealTime[
                                                  marketInfo?.offerPrice1Color],
                                            ),
                                            value: "${marketInfo?.offerPrice1}"
                                                    .isValidNumber
                                                ? double.tryParse(marketInfo
                                                        ?.offerPrice1Color
                                                        .toString() ??
                                                    '0')
                                                : null,
                                            type: HighLightType.PRICE,
                                            child: Text(
                                                "${marketInfo?.offerPrice1 ?? 0}"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    child: HighLight(
                                      symbol: marketInfo?.symbol,
                                      value: "$oQtty1".isValidNumber
                                          ? double.tryParse(oQtty1.toString())
                                          : null,
                                      type: HighLightType.PRICE,
                                      child: customTextStyleBody(
                                        text: Utils().formatNumber(oQtty1),
                                        txalign: TextAlign.end,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: (MediaQuery.of(context).size.width -
                                                38) /
                                            2 -
                                        60,
                                    height: 20,
                                    alignment: Alignment.centerLeft,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width: (oQtty2 / maxQtty) *
                                              ((MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          38) /
                                                      2 -
                                                  60),
                                          decoration: BoxDecoration(
                                            color: backgroundColorRealTime[
                                                    marketInfo
                                                        ?.offerPrice2Color] ??
                                                colors,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        ),
                                        Positioned(
                                          left: 4,
                                          top: 1,
                                          child: HighLight(
                                            symbol: marketInfo?.symbol,
                                            textStyle: theme
                                                .textTheme.bodyMedium
                                                ?.copyWith(
                                              color: colorRealTime[
                                                  marketInfo?.offerPrice2Color],
                                            ),
                                            value: "${marketInfo?.offerPrice2}"
                                                    .isValidNumber
                                                ? double.tryParse(marketInfo
                                                        ?.offerPrice2Color
                                                        .toString() ??
                                                    '0')
                                                : null,
                                            type: HighLightType.PRICE,
                                            child: Text(
                                                "${marketInfo?.offerPrice2 ?? 0}"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    child: HighLight(
                                      symbol: marketInfo?.symbol,
                                      value: "$oQtty2".isValidNumber
                                          ? double.tryParse(oQtty2.toString())
                                          : null,
                                      type: HighLightType.PRICE,
                                      child: customTextStyleBody(
                                        text: Utils().formatNumber(oQtty2),
                                        txalign: TextAlign.end,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: (MediaQuery.of(context).size.width -
                                                38) /
                                            2 -
                                        60,
                                    height: 20,
                                    alignment: Alignment.centerLeft,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width: (oQtty3 / maxQtty) *
                                              ((MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          38) /
                                                      2 -
                                                  60),
                                          decoration: BoxDecoration(
                                            color: backgroundColorRealTime[
                                                    marketInfo
                                                        ?.offerPrice3Color] ??
                                                colors,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        ),
                                        Positioned(
                                          left: 4,
                                          top: 1,
                                          child: HighLight(
                                            symbol: marketInfo?.symbol,
                                            textStyle: theme
                                                .textTheme.bodyMedium
                                                ?.copyWith(
                                              color: colorRealTime[
                                                  marketInfo?.offerPrice3Color],
                                            ),
                                            value: "${marketInfo?.offerPrice3}"
                                                    .isValidNumber
                                                ? double.tryParse(marketInfo
                                                        ?.offerPrice3Color
                                                        .toString() ??
                                                    '0')
                                                : null,
                                            type: HighLightType.PRICE,
                                            child: Text(
                                                "${marketInfo?.offerPrice3 ?? 0}"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    child: HighLight(
                                      symbol: marketInfo?.symbol,
                                      value: "$oQtty3".isValidNumber
                                          ? double.tryParse(oQtty3.toString())
                                          : null,
                                      type: HighLightType.PRICE,
                                      child: customTextStyleBody(
                                        text: Utils().formatNumber(oQtty3),
                                        txalign: TextAlign.end,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          // Container(
          //   margin:
          //       const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          //   padding:
          //       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //   decoration: BoxDecoration(
          //     color: Theme.of(context).colorScheme.tertiary,
          //     borderRadius: BorderRadius.circular(4),
          //   ),
          //   child: Column(
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           customTextStyleBody(
          //             text: "Tổng khối lượng giao dịch",
          //             color:
          //                 Theme.of(context).textTheme.titleSmall!.color!,
          //             size: 10,
          //             fontWeight: FontWeight.w400,
          //           ),
          //           customTextStyleBody(
          //             text: "852,000 cp",
          //             color: Theme.of(context).primaryColor,
          //             fontWeight: FontWeight.w500,
          //           ),
          //         ],
          //       ),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           customTextStyleBody(
          //             text: "Giá trị giao dịch",
          //             color:
          //                 Theme.of(context).textTheme.titleSmall!.color!,
          //             size: 10,
          //             fontWeight: FontWeight.w400,
          //           ),
          //           customTextStyleBody(
          //             text: "8,84 tỷ",
          //             color: Theme.of(context).primaryColor,
          //             fontWeight: FontWeight.w500,
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          // Divider(
          //   color: Theme.of(context).colorScheme.secondary,
          //   height: 1,
          // ),
          Container(
            margin: const EdgeInsets.only(top: 12, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     customTextStyleBody(
                //       text: "Khớp lệnh",
                //       size: 20,
                //       color: Theme.of(context).primaryColor,
                //       fontWeight: FontWeight.w700,
                //     ),
                //     customTextStyleBody(
                //       text: "Xem toàn bộ",
                //       color: Theme.of(context).secondaryHeaderColor,
                //       fontWeight: FontWeight.w400,
                //     ),
                //   ],
                // ),
                // const SizedBox(
                //   height: 16,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Column(
                //       children: [
                //         customTextStyleBody(
                //           text: "Tổng KL khớp",
                //           color: Theme.of(context)
                //               .textTheme
                //               .titleSmall!
                //               .color!,
                //           fontWeight: FontWeight.w400,
                //           size: 10,
                //         ),
                //         const SizedBox(
                //           height: 4,
                //         ),
                //         customTextStyleBody(
                //           text: "857,999",
                //           color: Theme.of(context).primaryColor,
                //           fontWeight: FontWeight.w700,
                //         )
                //       ],
                //     ),
                //     Column(
                //       children: [
                //         customTextStyleBody(
                //           text: "KL MUA chủ động",
                //           color: Theme.of(context)
                //               .textTheme
                //               .titleSmall!
                //               .color!,
                //           fontWeight: FontWeight.w400,
                //           size: 10,
                //         ),
                //         const SizedBox(
                //           height: 4,
                //         ),
                //         customTextStyleBody(
                //           text: "857,999",
                //           color: Theme.of(context).primaryColor,
                //           fontWeight: FontWeight.w700,
                //         )
                //       ],
                //     ),
                //     Column(
                //       children: [
                //         customTextStyleBody(
                //           text: "KL BÁN chủ dộng",
                //           color: Theme.of(context)
                //               .textTheme
                //               .titleSmall!
                //               .color!,
                //           fontWeight: FontWeight.w400,
                //           size: 10,
                //         ),
                //         const SizedBox(
                //           height: 4,
                //         ),
                //         customTextStyleBody(
                //           text: "857,999",
                //           color: Theme.of(context).primaryColor,
                //           fontWeight: FontWeight.w700,
                //         )
                //       ],
                //     ),
                //   ],
                // ),
                customTextStyleBody(
                  text: "Khớp lệnh",
                  size: 20,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w700,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Divider(
                    height: 1,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                SizedBox(
                  height: 31,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 62,
                        child: customTextStyleBody(
                          text: "Thời gian",
                          color: Theme.of(context).textTheme.titleSmall!.color!,
                          fontWeight: FontWeight.w400,
                          txalign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        width: 63,
                        child: customTextStyleBody(
                          text: "Giá",
                          color: Theme.of(context).textTheme.titleSmall!.color!,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 88,
                        child: customTextStyleBody(
                          text: "+/-",
                          color: Theme.of(context).textTheme.titleSmall!.color!,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 79,
                        child: customTextStyleBody(
                          text: "KL",
                          color: Theme.of(context).textTheme.titleSmall!.color!,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: customTextStyleBody(
                          text: "Mua/bán",
                          color: Theme.of(context).textTheme.titleSmall!.color!,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                for (var i = 0; i < dataKhopLenh.length; i++)
                  SizedBox(
                    height: 38,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 62,
                          child: customTextStyleBody(
                            text: DateFormat("HH:mm:ss").format(
                                DateFormat("HH:mm:ss.S").parse(
                                    dataKhopLenh[i]['tradeTime'] ?? "0")),
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                            txalign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          width: 63,
                          child: customTextStyleBody(
                            text:
                                "${(dataKhopLenh[i]['matchPrice'] ?? 0) / 1000}",
                            color: dataKhopLenh[i]['changePrice'] < 0
                                ? Colors.red
                                : (dataKhopLenh[i]['changePrice'] == 0)
                                    ? Colors.yellow
                                    : Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 88,
                          child: customTextStyleBody(
                            text:
                                "${(dataKhopLenh[i]['changePrice'] ?? 0) / 1000}",
                            color: dataKhopLenh[i]['changePrice'] < 0
                                ? Colors.red
                                : (dataKhopLenh[i]['changePrice'] == 0)
                                    ? Colors.yellow
                                    : Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 79,
                          child: customTextStyleBody(
                            text: Utils().formatNumber(
                                dataKhopLenh[i]['matchQtty'] ?? 0),
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: customTextStyleBody(
                            text: (dataKhopLenh[i]['side'] ?? '') == 'S'
                                ? "B"
                                : "M",
                            color: dataKhopLenh[i]['side'] == 'S'
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
