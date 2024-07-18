// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/model/cash_info.dart';
import 'package:nvs_trading/presentation/view/asset_page/saoketien.dart';
import 'package:nvs_trading/presentation/view/asset_page/widget/list_Asset.dart';
import 'package:nvs_trading/presentation/view/asset_page/widget/vachke.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';

class MoneyInfo extends StatefulWidget {
  MoneyInfo({
    super.key,
    required this.cashInfo,
  });

  List<CashInfoModel> cashInfo;

  @override
  State<MoneyInfo> createState() => _MoneyInfoState();
}

class _MoneyInfoState extends State<MoneyInfo> {
  String acctno = HydratedBloc.storage.read('acctno');
  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customTextStyleBody(
                text: appLocal.assetMoneyForm('accountbalance'),
                size: 14,
                color: Theme.of(context).secondaryHeaderColor,
                txalign: TextAlign.start,
              ),
              SizedBox(
                height: 20,
                width: 90,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const saoketien()));
                  },
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(
                        color: Theme.of(context).secondaryHeaderColor),
                  )),
                  child: FittedBox(
                    fit: BoxFit.none,
                    child: customTextStyleBody(
                      text: appLocal.assetMoneyForm('moneystate'),
                      color: Theme.of(context).secondaryHeaderColor,
                      size: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // suc mua => done
          (acctno.endsWith("NM"))
              ? Column(
                  children: [
                    ListAsset(
                      text: appLocal.assetMoneyForm('buyingPower'),
                      money: Utils()
                          .formatNumber(widget.cashInfo.first.buyingpower ?? 0),
                    ),
                    const Vachke(),
                  ],
                )
              : Container(),
          //tien mat => done
          (acctno.endsWith("NM"))
              ? Container()
              : Column(
                  children: [
                    ListAsset(
                      text: appLocal.assetMoneyForm('cash'),
                      money: Utils().formatNumber(
                        widget.cashInfo.first.balance ?? 0,
                      ),
                    ),
                    const Vachke(),
                  ],
                ),
          //tien mat co the rut => done
          Column(
            children: [
              ListAsset(
                text: appLocal.assetMoneyForm('casha4w'),
                money: Utils()
                    .formatNumber(widget.cashInfo.first.withdrawalvalue ?? 0),
              ),
              const Vachke(),
            ],
          ),

          //So tien phong toa => done
          Column(
            children: [
              ListAsset(
                  text: appLocal.assetMoneyForm('lockedfunds'),
                  money: Utils()
                      .formatNumber(widget.cashInfo.first.blockeD_VALUE ?? 0)),
              const Vachke(),
            ],
          ),

          //Tien ban co the ung => done
          Column(
            children: [
              ListAsset(
                text: appLocal.assetMoneyForm('asf'),
                money: Utils().formatNumber(widget.cashInfo.first.advamt ?? 0),
              ),
              const Vachke(),
            ],
          ),

          //Tien cho ve => done
          (acctno.endsWith("NM"))
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    customTextStyleBody(
                      text: appLocal.assetMoneyForm('mps'),
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    ListAsset(
                        text: "• ${appLocal.assetMoneyForm('pfss')} T1",
                        money: Utils()
                            .formatNumber(widget.cashInfo.first.t1 ?? 0)),
                    ListAsset(
                        text: "• ${appLocal.assetMoneyForm('pfss')} T0",
                        money: Utils()
                            .formatNumber(widget.cashInfo.first.t0 ?? 0)),
                    const Vachke(),
                  ],
                )
              : Container(),

          //mua cho khop => done
          Column(
            children: [
              ListAsset(
                text: appLocal.assetMoneyForm('buypending'),
                money: Utils().formatNumber(
                  int.parse(
                    widget.cashInfo.first.buypendingvl!.toStringAsFixed(0),
                  ),
                ),
              ),
              const Vachke(),
            ],
          ),

          //co tuc => done
          Column(
            children: [
              ListAsset(
                  text: appLocal.assetMoneyForm('dividend'),
                  money: Utils()
                      .formatNumber(widget.cashInfo.first.dividendvalue ?? 0)),
              const Vachke(),
            ],
          ),

          //No phi LK => done
          (acctno.endsWith("NM"))
              ? Column(
                  children: [
                    ListAsset(
                        text: appLocal.assetMoneyForm('feedebt'),
                        money: Utils().formatNumber(
                            widget.cashInfo.first.custodyfee ?? 0)),
                    const Vachke(),
                  ],
                )
              : Container(),
          // tien banCK => done
          (acctno.endsWith("NM"))
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customTextStyleBody(
                      text: appLocal.assetMoneyForm('pfss'),
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    ListAsset(
                        text: "• ${appLocal.assetMoneyForm('pfss')} T1",
                        money: Utils()
                            .formatNumber(widget.cashInfo.first.t1 ?? 0)),
                    ListAsset(
                        text: "• ${appLocal.assetMoneyForm('pfss')} T0",
                        money: Utils()
                            .formatNumber(widget.cashInfo.first.t0 ?? 0)),
                    const Vachke(),
                  ],
                ),
        ],
      ),
    );
  }
}
