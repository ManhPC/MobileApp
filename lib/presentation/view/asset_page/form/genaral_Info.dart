// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/model/cash_info.dart';
import 'package:nvs_trading/presentation/view/asset_page/widget/list_Asset.dart';
import 'package:nvs_trading/presentation/view/asset_page/widget/vachke.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class GeneralInfo extends StatefulWidget {
  GeneralInfo({
    super.key,
    required this.cashInfo,
    required this.assetData,
    required this.indexAcctno,
  });

  List<CashInfoModel> cashInfo;
  List<dynamic> assetData;
  int indexAcctno;

  @override
  State<GeneralInfo> createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo> {
  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    var language = appLocal.localeName;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customTextStyleBody(
              text: appLocal.assetGeneralForm('assetInfo'),
              size: 14,
              color: Theme.of(context).secondaryHeaderColor,
              txalign: TextAlign.start,
            ),
            const SizedBox(
              height: 8,
            ),
            //Tổng TS thực tế: done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('totalactualassets'),
                  money: Utils().formatNumber(
                      widget.assetData[widget.indexAcctno]['totalasset']),
                ),
                const Vachke(),
              ],
            ),
            //TSR thực tế: done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('realnetassets'),
                  money: Utils().formatNumber(
                      widget.assetData[widget.indexAcctno]['nav']),
                ),
                const Vachke(),
              ],
            ),
            //Sức mua cơ bản : done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('basicbuyingpower'),
                  money: Utils().formatNumber(
                    widget.assetData[widget.indexAcctno]['buyingpower'] ?? 0,
                  ),
                ),
                const Vachke(),
              ],
            ),
            //Tiền mặt có thể rút : done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('casha4w'),
                  money: Utils().formatNumber(
                      widget.assetData[widget.indexAcctno]['withdrawable'] ??
                          0),
                ),
                const Vachke(),
              ],
            ),
            //Tiền mặt: done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('cash'),
                  money: Utils().formatNumber(
                    widget.assetData[widget.indexAcctno]['cash'] ?? 0,
                  ),
                ),
                const Vachke(),
              ],
            ),
            // Giá trị CK nắm giữ : done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('heldstockvalue'),
                  money: Utils().formatNumber(
                      widget.assetData[widget.indexAcctno]['marketvalue']),
                ),
                const Vachke(),
              ],
            ),
            // Tổng tài sản ký quỹ : done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('totalPA'),
                  money: Utils().formatNumber(widget
                      .assetData[widget.indexAcctno]['totalmarginassets']),
                ),
                const Vachke(),
              ],
            ),
            //Hạn mức TK : done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('accountlimit'),
                  money: Utils().formatNumber(
                      widget.assetData[widget.indexAcctno]['margiN_USED'] ?? 0),
                ),
                const Vachke(),
              ],
            ),
            //Tiền bán có thể ứng : done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('asf'),
                  money: Utils().formatNumber(
                      widget.assetData[widget.indexAcctno]['casH_AVAILABLE'] ??
                          0),
                ),
                const Vachke(),
              ],
            ),
            //GT CK chờ THQ : done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('pevs'),
                  money: Utils().formatNumber(
                      widget.assetData[widget.indexAcctno]['PENDRIGHTSVALUE'] ??
                          0),
                ),
                const Vachke(),
              ],
            ),
            //TSR ký quỹ : done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('npa'),
                  money: Utils().formatNumber(
                      widget.assetData[widget.indexAcctno]['marginnet'] ?? 0),
                ),
                const Vachke(),
              ],
            ),

            // % Lãi/ lỗ : done
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customTextStyleBody(
                        text: appLocal.assetGeneralForm('percentgainloss'),
                        color: Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w400,
                      ),
                      customTextStyleBody(
                        text:
                            "${widget.assetData[widget.indexAcctno]['glpercent']}%",
                        size: 14,
                        color: (widget.assetData[widget.indexAcctno]
                                    ['glpercent'] >
                                0)
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                const Vachke(),
              ],
            ),

            //Cổ tức : done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('dividend'),
                  money: Utils().formatNumber(
                      widget.assetData[widget.indexAcctno]
                              ['dividenD_WAITINGVL'] ??
                          0),
                ),
                const Vachke(),
              ],
            ),

            // CK ko cho vay : done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('SNAFL'),
                  money: Utils().formatNumber(
                      widget.assetData[widget.indexAcctno]
                              ['symbolnotloanvalue'] ??
                          0),
                ),
                const Vachke(),
              ],
            ),

            //Tổng nợ : done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('totaldebt'),
                  money: Utils().formatNumber(
                      widget.assetData[widget.indexAcctno]['totalfee'] ?? 0),
                ),
                const Vachke(),
              ],
            ),

            //RTT : done
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customTextStyleBody(
                        text: appLocal.assetGeneralForm('rttRatio'),
                        color: Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w400,
                      ),
                      customTextStyleBody(
                        text: "${widget.cashInfo.first.rtt} %",
                        size: 14,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                const Vachke(),
              ],
            ),

            //Tien phong toa : done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('lockedfunds'),
                  money: Utils().formatNumber(
                      widget.assetData[widget.indexAcctno]['blockeD_VALUE'] ??
                          0),
                ),
                const Vachke(),
              ],
            ),

            //CK cho vay : done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('SAFL'),
                  money: Utils().formatNumber(
                      widget.assetData[widget.indexAcctno]['symbolloanvalue'] ??
                          0),
                ),
                const Vachke(),
              ],
            ),

            // Nợ gốc : done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('principaldebt'),
                  money: Utils().formatNumber(
                      widget.assetData[widget.indexAcctno]['loanamt'] ?? 0),
                ),
                const Vachke(),
              ],
            ),

            //Số tiền cần bs : done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('ANFS'),
                  money: Utils().formatNumber(
                      widget.assetData[widget.indexAcctno]['amountadded'] ?? 0),
                ),
                const Vachke(),
              ],
            ),

            //mua chờ khớp: done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('buypending'),
                  money: Utils().formatNumber(
                      widget.assetData[widget.indexAcctno]['buY_MATCHVL'] ?? 0),
                ),
                const Vachke(),
              ],
            ),

            //Tổng giá trị vốn : done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('totalcapitalvalue'),
                  money: Utils().formatNumber(
                      widget.assetData[widget.indexAcctno]['costvalue'] ?? 0),
                ),
                const Vachke(),
              ],
            ),

            //Nợ lãi : done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('interestdebt'),
                  money: Utils().formatNumber(
                      widget.assetData[widget.indexAcctno]['acrintamt'] ?? 0),
                ),
                const Vachke(),
              ],
            ),

            //Trạng thái TK : done
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customTextStyleBody(
                        text: appLocal.assetGeneralForm('accountstatus'),
                        color: Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w400,
                      ),
                      customTextStyleBody(
                        text:
                            "${widget.assetData[widget.indexAcctno]['statusaccount']}",
                        size: 14,
                        color: (widget.assetData[widget.indexAcctno]
                                    ['statusaccount'] ==
                                "Bình thường")
                            ? Colors.green
                            : (widget.assetData[widget.indexAcctno]
                                        ['statusaccount'] ==
                                    "Cảnh báo")
                                ? Colors.yellow
                                : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                const Vachke(),
              ],
            ),

            //Mua trong ngày
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('BWTD'),
                  money: "0",
                ),
                const Vachke(),
              ],
            ),

            //Lãi/lỗ : done
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customTextStyleBody(
                        text: appLocal.assetGeneralForm('gainloss'),
                        color: Theme.of(context).textTheme.titleSmall!.color!,
                        fontWeight: FontWeight.w400,
                      ),
                      Row(
                        children: [
                          customTextStyleBody(
                            text: Utils().formatNumber(widget
                                    .assetData[widget.indexAcctno]['glvalue'] ??
                                0),
                            size: 14,
                            color: (widget.assetData[widget.indexAcctno]
                                        ['glvalue'] >
                                    0)
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                          customTextStyleBody(
                            text: " VND",
                            color:
                                Theme.of(context).textTheme.titleSmall!.color!,
                            size: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Vachke(),
              ],
            ),

            //Nợ phí LK : done
            Column(
              children: [
                ListAsset(
                  text: appLocal.assetGeneralForm('feedebt'),
                  money: Utils().formatNumber(
                      widget.assetData[widget.indexAcctno]['custodyfee'] ?? 0),
                ),
                const Vachke(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
