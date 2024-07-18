import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nvs_trading/common/utils/extensions/string_extensions.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/presentation/theme/color.dart';
import 'package:nvs_trading/presentation/view/bottom_bar/bottom_bar.dart';
import 'package:nvs_trading/presentation/view/homepage/stock_detail_screen/bang_gia.dart';
import 'package:nvs_trading/presentation/view/homepage/stock_detail_screen/bieu_do.dart';
import 'package:nvs_trading/presentation/view/homepage/stock_detail_screen/ho_so.dart';
import 'package:nvs_trading/presentation/view/homepage/stock_detail_screen/tai_chinh.dart';
import 'package:nvs_trading/presentation/view/homepage/stock_detail_screen/thong_ke.dart';
import 'package:nvs_trading/presentation/view/order/add_command.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_cubit.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_state.dart';
import 'package:nvs_trading/presentation/widget/highlight.dart';

import 'package:nvs_trading/presentation/widget/style/style_appbar.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class StockDetail extends StatefulWidget {
  StockDetail({
    super.key,
    required this.symbol,
    required this.market,
    required this.nameSymbol,
    required this.isStar,
  });

  String symbol;
  String market;
  String nameSymbol;
  bool isStar;
  @override
  State<StockDetail> createState() => _StockDetailState();
}

class _StockDetailState extends State<StockDetail> {
  int isSelect = 0;

  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
        title: Column(
          children: [
            customTextStyleAppbar(
              text: "${widget.symbol} (${widget.market})",
              color: Theme.of(context).primaryColor,
              size: 14,
              fontWeight: FontWeight.w500,
            ),
            customTextStyleAppbar(
              text: widget.nameSymbol,
              color: Theme.of(context).textTheme.titleSmall!.color!,
              size: 14,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 14,
          ),
        ),
        actions: [
          Icon(
            widget.isStar ? Icons.star : Icons.star_border,
            size: 24,
            color: widget.isStar ? Colors.yellow : null,
          ),
          const SizedBox(
            width: 8,
          ),
          const Icon(
            Icons.notifications_none,
            size: 24,
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<MarketInfoCubit, MarketInfoState>(
            builder: (context, state) {
              var colors = Theme.of(context).primaryColor;
              final theme = Theme.of(context);
              final marketInfo = state.marketInfo[widget.symbol];
              return Container(
                //height: 98,
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.primary,
                ),
                padding: const EdgeInsets.only(
                    left: 8, top: 4, bottom: 4, right: 39),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HighLight(
                          symbol: marketInfo?.symbol,
                          textStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: colorRealTime[marketInfo?.matchPriceColor] ??
                                colors,
                            fontSize: 34,
                            fontWeight: FontWeight.w500,
                          ),
                          value: "${marketInfo?.matchPrice}".isValidNumber
                              ? double.tryParse(
                                  marketInfo?.matchPrice.toString() ?? "0")
                              : null,
                          type: HighLightType.PRICE,
                          child: Text(
                            "${marketInfo?.matchPrice ?? 0}",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 2),
                          child: Row(
                            children: [
                              customTextStyleBody(
                                text: "${marketInfo?.changePrice ?? 0} / ",
                                color: colorRealTime[
                                        marketInfo?.changePriceColor] ??
                                    colors,
                                fontWeight: FontWeight.w400,
                              ),
                              customTextStyleBody(
                                text: "${marketInfo?.pctChangePrice ?? 0}%",
                                fontWeight: FontWeight.w400,
                                color: colorRealTime[
                                        marketInfo?.pctChangePriceColor] ??
                                    colors,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            customTextStyleBody(
                              text: "${appLocal.addCommandForm('totalvol')}: ",
                              fontWeight: FontWeight.w400,
                              size: 10,
                              color: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .color!,
                              txalign: TextAlign.start,
                            ),
                            customTextStyleBody(
                              text: Utils().formatNumber(
                                  marketInfo?.totalTradedQttyNM ?? 0),
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          height: 40,
                          width: 132,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customTextStyleBody(
                                    text: appLocal.addCommandForm('floor'),
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .color!,
                                    size: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  customTextStyleBody(
                                    text: "${marketInfo?.floorPrice ?? 0}",
                                    color: const Color(0xff0CC6DA),
                                    fontWeight: FontWeight.w500,
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customTextStyleBody(
                                    text: appLocal.addCommandForm('tc'),
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .color!,
                                    size: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  customTextStyleBody(
                                    text: "${marketInfo?.refPrice ?? 0}",
                                    color: const Color(0xffCCAC3D),
                                    fontWeight: FontWeight.w500,
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customTextStyleBody(
                                    text: appLocal.addCommandForm('ceil'),
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .color!,
                                    size: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  customTextStyleBody(
                                    text: "${marketInfo?.ceilPrice ?? 0}",
                                    color: const Color(0xffF23AFF),
                                    fontWeight: FontWeight.w500,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 36,
                          width: 132,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customTextStyleBody(
                                    text: appLocal.addCommandForm('lowest'),
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .color!,
                                    size: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  customTextStyleBody(
                                    text: "${marketInfo?.lowestPrice ?? 0}",
                                    color: const Color(0xffF04A47),
                                    fontWeight: FontWeight.w500,
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customTextStyleBody(
                                    text: appLocal.addCommandForm('avg'),
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .color!,
                                    size: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  customTextStyleBody(
                                    text: "${marketInfo?.avgPrice ?? 0}",
                                    color: const Color(0xffCCAC3D),
                                    fontWeight: FontWeight.w500,
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customTextStyleBody(
                                    text: appLocal.addCommandForm('highest'),
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .color!,
                                    size: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  customTextStyleBody(
                                    text: "${marketInfo?.highestPrice ?? 0}",
                                    color: const Color(0xff4FD08A),
                                    fontWeight: FontWeight.w500,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
          Container(
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelect = 0;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: (isSelect == 0)
                              ? BorderSide(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  width: 3,
                                )
                              : BorderSide.none,
                        ),
                      ),
                      child: customTextStyleBody(
                        text: "Bảng giá",
                        color: (isSelect == 0)
                            ? Theme.of(context).secondaryHeaderColor
                            : Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelect = 1;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: (isSelect == 1)
                              ? BorderSide(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  width: 3,
                                )
                              : BorderSide.none,
                        ),
                      ),
                      child: customTextStyleBody(
                        text: "Biểu đồ",
                        color: (isSelect == 1)
                            ? Theme.of(context).secondaryHeaderColor
                            : Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelect = 2;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: (isSelect == 2)
                              ? BorderSide(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  width: 3,
                                )
                              : BorderSide.none,
                        ),
                      ),
                      child: customTextStyleBody(
                        text: "Hồ sơ",
                        color: (isSelect == 2)
                            ? Theme.of(context).secondaryHeaderColor
                            : Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelect = 3;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: (isSelect == 3)
                              ? BorderSide(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  width: 3,
                                )
                              : BorderSide.none,
                        ),
                      ),
                      child: customTextStyleBody(
                        text: "Thống kê",
                        color: (isSelect == 3)
                            ? Theme.of(context).secondaryHeaderColor
                            : Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelect = 4;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: (isSelect == 4)
                              ? BorderSide(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  width: 3,
                                )
                              : BorderSide.none,
                        ),
                      ),
                      child: customTextStyleBody(
                        text: "Tài chính",
                        color: (isSelect == 4)
                            ? Theme.of(context).secondaryHeaderColor
                            : Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelect = 5;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: (isSelect == 5)
                              ? BorderSide(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  width: 3,
                                )
                              : BorderSide.none,
                        ),
                      ),
                      child: customTextStyleBody(
                        text: "Tin tức",
                        color: (isSelect == 5)
                            ? Theme.of(context).secondaryHeaderColor
                            : Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: (isSelect == 0)
                ? BangGia(
                    symbol: widget.symbol,
                  )
                : (isSelect == 1)
                    ? BieuDo(
                        symbol: widget.symbol,
                      )
                    : (isSelect == 2)
                        ? HoSo(
                            symbol: widget.symbol,
                          )
                        : (isSelect == 3)
                            ? ThongKe(
                                symbol: widget.symbol,
                              )
                            : (isSelect == 4)
                                ? TaiChinh(
                                    symbol: widget.symbol,
                                  )
                                : Container(),
          ),
          const SizedBox(
            height: 60,
          ),
        ],
      ),
      bottomSheet: Container(
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        height: 60,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Theme.of(context).buttonTheme.colorScheme!.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: customTextStyleBody(
            text: "Đặt lệnh",
            color: Theme.of(context).buttonTheme.colorScheme!.primary,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => BottomBar(
                  current: 2,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
